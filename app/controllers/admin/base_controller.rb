class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate

  def authenticate
    authenticate_or_request_with_http_basic "Log in." do |name, password|
      name == ENV["ADMIN_NAME"] && password == ENV["ADMIN_PASSWORD"]
    end
  end
end
