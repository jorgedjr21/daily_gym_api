class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
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
end
