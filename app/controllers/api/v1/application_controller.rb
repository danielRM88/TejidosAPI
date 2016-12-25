module Api::V1
  class ApplicationController < ActionController::API
    include Knock::Authenticable
    # before_action authenticate
    # undef_method :current_user

    private

    def authenticate_v1_user
      authenticate_for User
    end
  end
end