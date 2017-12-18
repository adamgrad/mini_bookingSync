require 'rails_helper'
require 'api/v1/rentals_controller'

RSpec.describe RentalsController, type: :controller do
  before :each do
    request.headers["Authorization"] = "Token token=SPAFOISFO2RFJ209FJ23"
  end
  describe '#index' do
    it 'responds successfully' do
      get :index
      expect(response).to have_http_status 200
    end
  end
end
