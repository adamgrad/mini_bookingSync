require 'rails_helper'
require 'api/v1/rentals_controller'

RSpec.describe 'Rentals API', type: :request do
  describe 'GET /rentals' do
    context 'as an authorized user' do
      before do
        get '/rentals', params: {}, headers: { Authorization: "Token #{ENV['API_TOKEN']}"}
      end

      it 'returns a 200 response' do
        expect(response.status).to eq 200
      end

      it 'returns data array' do
        expect(parsed_body['data']).to be_an(Array)
      end
    end

    context 'as an unauthorized user' do
      it 'returns a 401 response' do
        get '/rentals'
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'POST /rentals' do
    context 'as an authorized user' do
      context 'with valid attributes' do
        before do
          rental_attributes = FactoryBot.attributes_for(:rental)
          expect {
            post '/rentals', params: create_jsonapi_rental_hash(rental_attributes).to_json,
              headers: headers(ENV['API_TOKEN'])
          }.to change(Rental, :count).by(1)
        end

        it 'returns a 201 response' do
          expect(response).to have_http_status 201
        end

        it 'returns data array' do
          expect(parsed_body['data']).not_to be_empty
        end
      end

      context 'with invalid attributes' do
        context 'invalid name' do
          it 'doesn\'t create a rental (442)' do
            rental_attributes = FactoryBot.attributes_for(:rental, name: nil)
            expect {
              post '/rentals', params: create_jsonapi_rental_hash(rental_attributes).to_json,
                headers: headers(ENV['API_TOKEN'])
            }.not_to change(Rental, :count)

            expect(response).to have_http_status 422
          end
        end

        context 'invalid daily rate' do
          it 'doesn\'t create a rental (442)' do
            rental_attributes = FactoryBot.attributes_for(:rental, daily_rate: nil)
            expect {
              post '/rentals', params: create_jsonapi_rental_hash(rental_attributes).to_json,
                headers: headers(ENV['API_TOKEN'])
            }.not_to change(Rental, :count)

            expect(response).to have_http_status 422
          end
        end
      end
    end

    context 'as an unauthorized user' do
      it 'returns a 401 response' do
        rental_attributes = FactoryBot.attributes_for(:rental)
        expect {
          post '/rentals', params: create_jsonapi_rental_hash(rental_attributes).to_json,
            headers: headers('InvalidToken')
        }.not_to change(Rental, :count)

        expect(response).to have_http_status 401
      end

    end
  end

  describe 'PATCH /rentals/:rental' do
    before do
      @rental = FactoryBot.create(:rental)
      @name = @rental.name
    end

    context 'as an authorized user' do
      context 'with valid attributes' do
        before do
          rental_params = FactoryBot.attributes_for(:rental, name: 'New Rental Name')
          patch rental_path(@rental), params: update_jsonapi_rental_hash(rental_params, @rental.id),
            headers: headers(ENV['API_TOKEN'])
        end

        it 'updates rental' do
          expect(@rental.reload.name).to eq 'New Rental Name'
        end

        it 'returns a 200 response' do
          expect(response).to have_http_status 200
        end

        it 'returns data array' do
          expect(parsed_body).not_to be_empty
        end
      end

      context 'with invalid attributes' do
        it 'doesn\'t update rental' do
          rental_params = FactoryBot.attributes_for(:rental, name: nil)
          patch rental_path(@rental), params: update_jsonapi_rental_hash(rental_params, @rental.id),
                                      headers: headers(ENV['API_TOKEN'])
          expect(response).to have_http_status 422
          expect(@rental.reload.name).to eq @name
        end
      end
    end

    context 'as an unauthorized user' do
      it 'returns a 401 response' do
        rental_params = FactoryBot.attributes_for(:rental, name: 'Unauthorized')
        patch rental_path(@rental), params: update_jsonapi_rental_hash(rental_params, @rental.id),
                                    headers: headers('InvalidToken')
        expect(response).to have_http_status 401
        expect(@rental.reload.name).to eq @name
      end
    end
  end

  describe 'DELETE /rentals/:rental' do
    before do
      @rental = FactoryBot.create(:rental)
    end

    context 'as an authorized user' do
      it 'deletes rental (204)' do
        expect {
          delete rental_path(@rental), params: {}, headers: headers(ENV['API_TOKEN'])
        }.to change(Rental, :count).by(-1)
        expect(response).to have_http_status 204
      end
    end

    context 'as an unauthorized user' do
      it 'doesn\'t delete rental' do
        expect {
          delete rental_path(@rental), params: {}, headers: headers('InvalidToken')
        }.not_to change(Rental, :count)
        expect(response).to have_http_status 401
      end
    end
  end

  def parsed_body
    JSON.parse(response.body)
  end

  def create_jsonapi_rental_hash(attributes)
    { data:
      { type: 'rentals',
        attributes: attributes.transform_keys { |key| key.to_s.dasherize }
      }
    }
  end

  def update_jsonapi_rental_hash(attributes, id)
    h1 = { data: { id: id } }
    create_jsonapi_rental_hash(attributes).deep_merge(h1).to_json
  end

  def headers(token)
    { Authorization: "Token #{token}", 'Content-type': 'application/vnd.api+json' }
  end
end
