class Rental < ApplicationRecord
  has_many :bookings

  validates :name, presence: true, length: { maximum: 50 }
  validates :daily_rate, presence: true
end
