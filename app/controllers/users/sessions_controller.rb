class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # POST /users/sign_in
  def create
    super do |resource|
      render json: {
        user: {
          id: resource.id,
          email: resource.email
        },
        token: current_token
      }, status: :ok and return
    end
  end

  # DELETE /users/sign_out
  def destroy
    super do |resource|
      head :no_content and return
    end
  end

  private
  def respond_to_on_destroy
    if current_user
      head :no_content
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  def current_token
    request.env["warden-jwt_auth.token"]
  end
end
