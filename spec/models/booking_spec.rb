require 'rails_helper'

RSpec.describe Booking, type: :model do
  it 'has a valid factory' do
    booking = FactoryBot.create(:booking)
    expect(booking).to be_valid


  end
end
