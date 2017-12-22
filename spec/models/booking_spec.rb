require "rails_helper"

RSpec.describe Booking, type: :model do
  it { is_expected.to validate_presence_of(:start_at) }

  it { is_expected.to validate_presence_of(:end_at) }

  it { is_expected.to validate_presence_of(:price) }

  it { is_expected.to validate_presence_of(:client_email) }

  it "can't end before start date" do
    booking = FactoryBot.build(:booking, :ends_before_start_at)
    expect(booking).not_to be_valid
    expect(booking.errors[:end_at]).to include "must be after or equal to #{I18n.localize(booking.start_at)}"
  end
end
