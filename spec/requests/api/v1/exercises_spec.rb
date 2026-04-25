require 'rails_helper'

RSpec.describe "Api::V1::Exercises", type: :request do
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, :admin) }

  let(:auth_headers_for) do
    ->(u) {
      post '/users/sign_in', params: { email: u.email, password: u.password }, as: :json
      token = JSON.parse(response.body)["token"]
      { "Authorization" => token, "Content-Type" => "application/json" }
    }
  end

  let(:headers) { auth_headers_for.call(user) }
  let(:admin_headers) { auth_headers_for.call(admin_user) }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /exercises" do
    let(:get_request) do
      get "/api/v1/exercises", headers: headers
    end
    context 'when authenticated' do
      it "returns all exercises for authenticated users" do
        create(:exercise)
        get_request

        expect(response).to have_http_status(:ok)
        expect(response_body.size).to eq(1)
      end
    end

    context "when unauthenticated" do
      let(:headers) { nil }
      it "returns unauthorized status" do
        get_request

        expect(response).to have_http_status(:unauthorized)
        expect(response_body).to eq({ "error" => "You need to sign in or sign up before continuing." })
      end
    end
  end

  describe "GET /api/v1/exercises/:id" do
    let(:exercise) { create(:exercise) }
    let(:get_request) { get "/api/v1/exercises/#{exercise.id}", headers: headers }

    context "when authenticated" do
      it "returns the requested exercise" do
        get_request

        expect(response).to have_http_status(:ok)
        expect(response_body["name"]).to eq(exercise.name)
        expect(response_body["id"]).to eq(exercise.id)
      end

      it "returns not found for a non-existing exercise" do
        get "/api/v1/exercises/999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response_body).to eq({ "error" => "Exercise not found" })
      end
    end

    context "when unauthenticated" do
      let(:headers) { nil }
      it "returns unauthorized status" do
        get_request
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/exercises" do
    let(:params) do
      {
        exercise: { name: "Push-ups", description: "A basic bodyweight exercise" }
      }
    end

    let(:post_request_as_admin) do
      post "/api/v1/exercises", params: params.to_json, headers: admin_headers
    end

    let(:post_request_as_user) do
      post "/api/v1/exercises", params: params.to_json, headers: headers
    end

    context "when admin" do
      it "creates a new exercise" do
        expect { post_request_as_admin }.to change(Exercise, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response_body["name"]).to eq("Push-ups")
        expect(response_body["description"]).to eq("A basic bodyweight exercise")
      end

      context 'with invalid params' do
        let(:params) do
          {
            exercise: { name: "", description: "A basic bodyweight exercise" }
          }
        end

        it "returns unprocessable entity" do
          post_request_as_admin

          expect(response).to have_http_status(:unprocessable_content)
          expect(response_body).to eq({ "errors" => [ "Name can't be blank" ] })
        end
      end
    end

    context "when regular user (non-admin)" do
      it "returns forbidden" do
        post_request_as_user

        expect(response).to have_http_status(:forbidden)
        expect(response_body["error"]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        post "/api/v1/exercises", params: params.to_json, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /api/v1/exercises/:id" do
    let(:exercise) { create(:exercise) }
    let(:exercise_id) { exercise.id }
    let(:params) do
      {
        exercise: { description: "Updated description" }
      }
    end

    let(:put_request_as_admin) do
      put "/api/v1/exercises/#{exercise_id}", params: params.to_json, headers: admin_headers
    end

    let(:put_request_as_user) do
      put "/api/v1/exercises/#{exercise_id}", params: params.to_json, headers: headers
    end

    context "when admin" do
      it "updates the exercise" do
        put_request_as_admin

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["description"]).to eq("Updated description")
      end

      context 'with invalid params' do
        let(:params) do
          {
            exercise: { name: "" }
          }
        end

        it "returns unprocessable entity for invalid params" do
          put_request_as_admin

          expect(response).to have_http_status(:unprocessable_content)
          expect(JSON.parse(response.body)).to eq({ "errors" => [ "Name can't be blank" ] })
        end
      end

      context 'with non-existing exercise' do
        let(:exercise_id) { 999 }

        it "returns not found" do
          put_request_as_admin

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to eq({ "error" => "Exercise not found" })
        end
      end
    end

    context "when regular user (non-admin)" do
      it "returns forbidden" do
        put_request_as_user

        expect(response).to have_http_status(:forbidden)
        expect(response_body["error"]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        put "/api/v1/exercises/#{exercise_id}", params: params.to_json, headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/exercises/:id" do
    let!(:exercise) { create(:exercise) }
    let(:exercise_id) { exercise.id }

    let(:delete_request_as_admin) do
      delete "/api/v1/exercises/#{exercise_id}", headers: admin_headers
    end

    let(:delete_request_as_user) do
      delete "/api/v1/exercises/#{exercise_id}", headers: headers
    end

    context "when admin" do
      it "deletes the exercise" do
        expect { delete_request_as_admin }.to change(Exercise, :count).by(-1)

        expect(response).to have_http_status(:no_content)
        expect(Exercise.exists?(exercise.id)).to be_falsey
      end

      context "with a non-existing exercise" do
        let(:exercise_id) { 999 }

        it "returns not found" do
          delete_request_as_admin

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to eq({ "error" => "Exercise not found" })
        end
      end
    end

    context "when regular user (non-admin)" do
      it "returns forbidden" do
        delete_request_as_user

        expect(response).to have_http_status(:forbidden)
        expect(response_body["error"]).to eq("You are not authorized to perform this action.")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        delete "/api/v1/exercises/#{exercise_id}", headers: nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
