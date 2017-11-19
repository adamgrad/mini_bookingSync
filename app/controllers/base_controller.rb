  class BaseController < ActionController::Base
    include JSONAPI::ActsAsResourceController
    include ActionController::HttpAuthentication::Token::ControllerMethods

    before_action :authenticate_by_token

    protected

    def authenticate_by_token
      authenticate_or_request_with_http_token do |token, options|
        ActiveSupport::SecurityUtils.secure_compare(
            ::Digest::SHA256.hexdigest(token),
            ::Digest::SHA256.hexdigest(ENV['API_TOKEN'])
        )
      end
    end
  end
