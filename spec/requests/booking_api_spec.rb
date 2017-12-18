require 'rails_helper'
require 'api/v1/bookings_controller'

RSpec.describe 'Bookings API', type: :request do
  describe 'GET /bookings' do
    context 'as an autorized user' do
      before do
        get '/bookings', params: {}, headers: headers
      end

      it 'returns a 200 response' do
        expect(response).to have_http_status 200
      end

      it 'returns a data array' do
        expect(parsed_body['data']).to be_an(Array)
      end
    end

    context 'as an aunauthorized user' do
      it 'returns a 401 response' do
        get '/bookings'
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'POST /bookings' do
    context 'as an autorized user' do
      context 'with valid attributes' do
        before do
          @rental = FactoryBot.create(:rental, name: 'Specific Rental')
          booking_attributes = FactoryBot.attributes_for(:booking, rental: @rental)
          expect {
            post '/bookings', params: create_jsonapi_booking_hash(@rental.id, booking_attributes).to_json,
                              headers: headers
          }.to change(Booking, :count).by(1)

        end

        it 'returns a 201 response' do
          expect(response).to have_http_status 201
        end

        it 'returns data array' do
          expect(parsed_body['data']).not_to be_empty
        end

        it 'belongs to a specific rental' do
          expect(fetch_rental_id).to eql @rental.id.to_s
        end

      end

      context 'with invalid attributes' do
        it 'doesn\'t create a booking without start date' do
          rental = FactoryBot.create(:rental)
          booking_attributes = FactoryBot.attributes_for(:booking, rental: rental, start_at: nil)
          expect {
            post '/bookings', params: create_jsonapi_booking_hash(rental.id, booking_attributes).to_json,
                              headers: headers
          }.not_to change(Booking, :count)

          expect(response).to have_http_status 422
        end
      end
    end

    context 'as an unauthorized user' do
      it 'returns a 401 response' do
        rental = FactoryBot.create(:rental)
        booking_attributes = FactoryBot.attributes_for(:booking)
        expect {
          post '/bookings', params: create_jsonapi_booking_hash(rental.id, booking_attributes).to_json,
            headers: headers('InvalidToken')
        }.not_to change(Booking, :count)

        expect(response).to have_http_status 401
      end
    end
  end

  describe 'PATCH /bookings/:booking' do
    before do
      @booking = FactoryBot.create(:booking)
      @client_email = @booking.client_email
    end

    context 'as an authorized user' do
      context 'with valid attributes' do
        before do
          booking_params = FactoryBot.attributes_for(:booking, client_email: 'new@mail.com')
          patch booking_path(@booking),
            params: update_jsonapi_booking_hash(@booking.id, @booking.rental.id, booking_params),
            headers: headers
        end

        it 'updates booking' do
          expect(@booking.reload.client_email).to eq 'new@mail.com'
        end

        it 'returns a 200 response' do
          expect(response).to have_http_status 200
        end

        it 'returns data array' do
          expect(parsed_body['data']).not_to be_empty
        end
      end

      context 'with invalid attributes' do
        before do
          booking_params = FactoryBot.attributes_for(:booking, client_email: nil)
          patch booking_path(@booking),
            params: update_jsonapi_booking_hash(@booking.id, @booking.rental.id, booking_params),
            headers: headers
        end

        it 'doesn\'t update booking' do
          expect(@booking.reload.client_email).to eq @client_email
        end

        it 'returns errors' do
          expect(parsed_body['errors']).not_to be_empty
        end
      end
    end

    context 'as an aunauthorized user' do
      before do
        booking_params = FactoryBot.attributes_for(:booking, client_email: 'new@mail.com')
        patch booking_path(@booking),
          params: update_jsonapi_booking_hash(@booking.id, @booking.rental.id, booking_params),
          headers: headers('InvalidToken')
      end

      it 'doesn\'t update booking' do
        expect(@booking.reload.client_email).to eq @client_email
      end

      it 'returns a 401 response' do
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'DELETE /bookings/:booking' do
    before do
      @booking = FactoryBot.create(:booking)
    end

    context 'as an authorized user' do
      it 'deletes booking (204)' do
        expect {
          delete booking_path(@booking), params: {}, headers: headers
        }.to change(Booking, :count).by(-1)
        expect(response).to have_http_status 204
      end
    end

    context 'as an aunauthorized user' do
      it 'returns a 401 response' do
        expect {
          delete booking_path(@booking), params: {}, headers: headers('InvalidToken')
        }.not_to change(Booking, :count)
        expect(response).to have_http_status 401
      end
    end
  end

  def fetch_rental_id
    parsed_body.fetch('data').fetch('relationships').fetch('rental').fetch('data').fetch('id')
  end

  def parsed_body
    JSON.parse(response.body)
  end

  def headers(token = ENV['API_TOKEN'])
    { Authorization: "Token #{token}", 'Content-type': 'application/vnd.api+json' }
  end

  def create_jsonapi_booking_hash(rental_id, attributes)
    { data:
      { type: "bookings",
        relationships:
          { rental:
            { data:
              { type: "rentals", id: rental_id} } },
        attributes: attributes.transform_keys { |key| key.to_s.dasherize }
      }
    }
  end

  def update_jsonapi_booking_hash(booking_id,rental_id, attributes)
    h1 = { data: { id: booking_id } }
    create_jsonapi_booking_hash(rental_id, attributes).deep_merge(h1).to_json
  end
end
