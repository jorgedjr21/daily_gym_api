require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  describe 'POST /users' do
    context 'when the request is valid' do
      let(:valid_attributes) do
        { user: { name: 'Test', email: 'test@example.com', password: 'password', password_confirmation: 'password' } }
      end

      it 'creates a new user' do
        expect {
          post '/users', params: valid_attributes
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).
          to include(
            valid_attributes[:user].
            except(:password, :password_confirmation).
            stringify_keys
          )
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) do
        { user: { email: 'test@example.com', password: 'password', password_confirmation: 'mismatch' } }
      end

      it 'does not create a new user' do
        expect {
          post '/users', params: invalid_attributes
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)

        expect(body).to include('errors')
      end
    end
  end
end
