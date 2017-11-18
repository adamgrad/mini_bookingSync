Rails.application.routes.draw do
  jsonapi_resources :rentals
  jsonapi_resources :bookings
end
