module Authorizable
  extend ActiveSupport::Concern

  private

  def require_admin!
    return if current_user&.role == "admin"

    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end
end
