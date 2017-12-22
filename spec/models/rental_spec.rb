require "rails_helper"

RSpec.describe Rental, type: :model do
  it "has a valid factory" do
    rental = FactoryBot.build(:rental)
    expect(rental).to be_valid
  end

  it "is invalid without a name" do
    rental = FactoryBot.build(:rental, :invalid_name)
    expect(rental).not_to be_valid
    expect(rental.errors[:name]).to include "can't be blank"
  end

  it "is invalid without a daily rate" do
    rental = FactoryBot.build(:rental, :invalid_daily_rate)
    expect(rental).not_to be_valid
    expect(rental.errors[:daily_rate]).to include "can't be blank"
  end
end
