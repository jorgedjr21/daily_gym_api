class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  rescue_from ActionController::RoutingError, with: :route_not_found
  rescue_from AbstractController::ActionNotFound, with: :route_not_found
  before_action :configure_permitted_parameters, if: :devise_controller?


  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: exception.message }, status: :not_found
  end

  def authenticate_user!
    unless user_signed_in?
      render json: { error: "You need to sign in or sign up before continuing." }, status: :unauthorized
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :email, :password ])
  end

  def route_not_found(exception = nil)
    render json: { error: "Route not found", message: exception&.message }, status: :not_found
  end
end
