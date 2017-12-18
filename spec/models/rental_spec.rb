require 'rails_helper'

RSpec.describe Rental, type: :model do
  it 'has a valid factory' do
    rental = FactoryBot.build(:rental)
    expect(rental).to be_valid
  end
end
