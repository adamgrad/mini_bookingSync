require 'rails_helper'

RSpec.describe Booking, type: :model do
  it 'has a valid factory' do
    booking = FactoryBot.create(:booking)
    expect(booking).to be_valid
  end

  it 'is invalid without a start date' do
    booking = FactoryBot.build(:booking, :invalid_start_at)
    expect(booking).not_to be_valid
    expect(booking.errors['start_at']).to include "can't be blank"
  end

  it 'is invalid without an end date' do
    booking = FactoryBot.build(:booking, :invalid_end_at)
    expect(booking).not_to be_valid
    expect(booking.errors['end_at']).to include "can't be blank"
  end

  it 'is invalid without a price' do
    booking = FactoryBot.build(:booking, :invalid_price)
    expect(booking).not_to be_valid
    expect(booking.errors['price']).to include "can't be blank"
  end

  it 'is invalid without a client email' do
    booking = FactoryBot.build(:booking, :invalid_client_email)
    expect(booking).not_to be_valid
    expect(booking.errors['client_email']).to include "can't be blank"
  end

  it 'can\'t end before start date' do
    booking = FactoryBot.build(:booking, :ends_before_start_at)
    expect(booking).not_to be_valid
    expect(booking.errors['end_at']).to include "must be after or equal to #{I18n.localize(booking.start_at)}"
  end
end
