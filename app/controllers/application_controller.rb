class ApplicationController < BaseController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format.include? 'application/json' }
end
