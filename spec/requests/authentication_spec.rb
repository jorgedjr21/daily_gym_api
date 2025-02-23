require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    context 'when credentials are correct' do
      it 'returns a JWT token' do
        post '/users/sign_in', params: { email: user.email, password: user.password }

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body).to include('token')
      end
    end

    context 'when credentials are incorrect' do
      it 'returns an unauthorized status' do
        post '/users/sign_in', params: { email: user.email, password: 'wrongpassword' }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid Email or Password')
      end
    end
  end

  describe 'DELETE /users/sign_out' do
    let(:logout_request) do
      delete '/users/sign_out', headers: { 'Authorization' => auth_token }
    end

    let(:auth_token) do
      post '/users/sign_in', params: { email: user.email, password: user.password }
      response.headers['Authorization']
    end

    it 'revokes the JWT token' do
      expect { logout_request }.
        to change(JwtBlacklist, :count).by(1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
