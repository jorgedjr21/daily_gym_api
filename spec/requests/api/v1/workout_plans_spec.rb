require 'rails_helper'

RSpec.describe "Api::V1::WorkoutPlans", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  let(:auth_headers_for) do
    ->(u) {
      post '/users/sign_in', params: { email: u.email, password: u.password }, as: :json
      token = JSON.parse(response.body)["token"]
      { "Authorization" => token, "Content-Type" => "application/json" }
    }
  end

  let(:headers) { auth_headers_for.call(user) }
  let(:response_body) { JSON.parse(response.body) }

  describe "GET /api/v1/workout_plans" do
    context "when authenticated" do
      it "returns only the current user's workout plans" do
        create(:workout_plan, user: user, name: "My Plan")
        create(:workout_plan, user: other_user, name: "Other Plan")

        get "/api/v1/workout_plans", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body.size).to eq(1)
        expect(response_body.first["name"]).to eq("My Plan")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        get "/api/v1/workout_plans"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/workout_plans/:id" do
    let(:workout_plan) { create(:workout_plan, user: user) }

    context "when authenticated" do
      it "returns the workout plan" do
        get "/api/v1/workout_plans/#{workout_plan.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body["id"]).to eq(workout_plan.id)
        expect(response_body["name"]).to eq(workout_plan.name)
      end

      it "returns not found for a non-existing workout plan" do
        get "/api/v1/workout_plans/999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response_body["error"]).to eq("Workout plan not found")
      end

      it "returns not found for another user's workout plan" do
        other_plan = create(:workout_plan, user: other_user)
        get "/api/v1/workout_plans/#{other_plan.id}", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response_body["error"]).to eq("Workout plan not found")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        get "/api/v1/workout_plans/#{workout_plan.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/workout_plans" do
    let(:valid_params) do
      { workout_plan: { name: "New Plan", description: "A new plan" } }
    end

    context "when authenticated" do
      it "creates a workout plan with name and description" do
        expect {
          post "/api/v1/workout_plans", params: valid_params.to_json, headers: headers
        }.to change(WorkoutPlan, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response_body["name"]).to eq("New Plan")
        expect(response_body["description"]).to eq("A new plan")
      end

      it "can receive workout_session_ids" do
        session1 = create(:workout_session, user: user)
        session2 = create(:workout_session, user: user)

        params = { workout_plan: { name: "Plan With Sessions", workout_session_ids: [ session1.id, session2.id ] } }
        post "/api/v1/workout_plans", params: params.to_json, headers: headers

        expect(response).to have_http_status(:created)
        expect(response_body["workout_sessions"].size).to eq(2)
      end

      it "returns unprocessable entity when name is blank" do
        post "/api/v1/workout_plans", params: { workout_plan: { name: "" } }.to_json, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(response_body["errors"]).to include("Name can't be blank")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        post "/api/v1/workout_plans", params: valid_params.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /api/v1/workout_plans/:id" do
    let(:workout_plan) { create(:workout_plan, user: user, name: "Old Name") }

    context "when authenticated" do
      it "updates the workout plan" do
        put "/api/v1/workout_plans/#{workout_plan.id}",
            params: { workout_plan: { name: "New Name" } }.to_json,
            headers: headers

        expect(response).to have_http_status(:ok)
        expect(response_body["name"]).to eq("New Name")
      end

      it "returns unprocessable entity when name is blank" do
        put "/api/v1/workout_plans/#{workout_plan.id}",
            params: { workout_plan: { name: "" } }.to_json,
            headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(response_body["errors"]).to include("Name can't be blank")
      end

      it "returns not found for a non-existing workout plan" do
        put "/api/v1/workout_plans/999",
            params: { workout_plan: { name: "Updated" } }.to_json,
            headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response_body["error"]).to eq("Workout plan not found")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        put "/api/v1/workout_plans/#{workout_plan.id}",
            params: { workout_plan: { name: "Updated" } }.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/workout_plans/:id" do
    let!(:workout_plan) { create(:workout_plan, user: user) }

    context "when authenticated" do
      it "deletes the workout plan" do
        expect {
          delete "/api/v1/workout_plans/#{workout_plan.id}", headers: headers
        }.to change(WorkoutPlan, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end

      it "returns not found for a non-existing workout plan" do
        delete "/api/v1/workout_plans/999", headers: headers

        expect(response).to have_http_status(:not_found)
        expect(response_body["error"]).to eq("Workout plan not found")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized status" do
        delete "/api/v1/workout_plans/#{workout_plan.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
