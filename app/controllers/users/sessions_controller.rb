class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # POST /users/sign_in
  def create
    user = User.find_for_database_authentication(email: sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      sign_in(user)
      render json: { user: { id: user.id, email: user.email }, token: current_token }, status: :ok
    else
      render json: { error: I18n.t("api.errors.invalid_credentials") }, status: :unauthorized
    end
  end

  # DELETE /users/sign_out
  def destroy
    super do |resource|
      render json: { message: I18n.t("api.success.signed_out") }, status: :no_content and return
    end
  end

  private

  def sign_in_params
    params[:session] ||= params # Ensure `session` key exists
    params.require(:session).permit(:email, :password)
  end

  def respond_with(resource, _opts = {})
    render json: {
      user: {
        id: resource.id,
        email: resource.email
      },
      token: current_token
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      head :no_content
    else
      render json: { error: I18n.t("api.errors.invalid_token") }, status: :unauthorized
    end
  end

  def current_token
    request.env["warden-jwt_auth.token"]
  end
end
