class BookingResource < JSONAPI::Resource
  attributes :start_at, :end_at, :client_email, :price
  has_one :rental
end
