class RentalResource < JSONAPI::Resource
  attributes :name, :daily_rate
  has_many :bookings
end
