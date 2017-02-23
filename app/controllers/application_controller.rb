class ApplicationController < ActionController::API
  include Knock::Authenticable
  undef_method :current_user
  respond_to :json
end
