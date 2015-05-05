module Api

  class ApiController < ApplicationController
    respond_to :json
    skip_before_action :verify_authenticity_token
    # protect_from_forgery with: :null_session

   def current_user
     @current_user ||= session[:user] && User.find_by_id(session[:user_id])
   end

    private

    def authenticated?
      authenticate_or_request_with_http_basic {|username, password| User.where( username: username, password: password).present? }
    end
  end
end