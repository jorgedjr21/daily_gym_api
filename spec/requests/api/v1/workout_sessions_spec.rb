require 'rails_helper'

RSpec.describe "Api::V1::WorkoutSessions", type: :request do
  let(:user) { create(:user) }
  let(:auth_token) do
    post '/users/sign_in', params: { email: user.email, password: user.password }, as: :json
    response.headers['Authorization']
  end
  let(:headers) { { "Authorization" => auth_token, "Content-Type" => "application/json" } }
  let(:exercise1) { create(:exercise, name: "Push-ups") }
  let(:exercise2) { create(:exercise, name: "Bench Press") }
  let(:exercise3) { create(:exercise, name: "Leg Press") }
  let!(:workout_session) { create(:workout_session, name: "Session A", user: user) }
  let(:response_body) do
    JSON.parse(response.body)
  end

  describe "GET /workout_sessions" do
    let(:get_request) do
      get "/api/v1/workout_sessions", headers: headers
    end

    context "when authenticated" do
      before { create(:workout_session, name: "Session B", user: user) }
      it "returns all workout sessions for the user" do
        get_request
        expect(response).to have_http_status(:ok)
        expect(response_body.size).to eq(2)
        expect(response_body.map { |s| s["name"] }).to contain_exactly("Session A", "Session B")
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

  describe "GET /workout_sessions/:id" do
    let(:workout_session_id) { workout_session.id }
    let(:get_request) do
      get "/api/v1/workout_sessions/#{workout_session_id}", headers: headers
    end

    context "when authenticated" do
      it "returns the workout session" do
        get_request

        expect(response).to have_http_status(:ok)
        expect(response_body["name"]).to eq("Session A")
      end

      context 'with non-existing workout session' do
        let(:workout_session_id) { 999 }

        it "returns not found" do
          get_request

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to eq({ "error" => "Workout session not found" })
        end
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

  describe "POST /workout_sessions" do
    let(:post_request) do
      post "/api/v1/workout_sessions", params: params.to_json, headers: headers
    end
    let(:params) do
      {
        workout_session: {
          name: "Session A",
          workout_session_exercises_attributes: [
            { exercise_id: exercise1.id, sets: 3, reps: 10, technique: nil, current_weight: nil },
            { exercise_id: exercise2.id, sets: 4, reps: 10, technique: "drop set", current_weight: 30 },
            { exercise_id: exercise3.id, sets: 4, reps: 10, technique: "30-second rest", current_weight: 140 }
          ]
        }
      }
    end

    context 'with authenticated user' do
      context 'with correct params' do
        it "creates a workout session with exercises" do
          expect { post_request }.to change(WorkoutSessionExercise, :count).by(3)
          expect(response).to have_http_status(:created)
          expect(response_body["name"]).to eq("Session A")
        end
      end

      context 'with invalid data' do
        let(:params) do
          {
            workout_session: {
              name: "",
              workout_session_exercises_attributes: [
                { exercise_id: exercise1.id, sets: nil, reps: nil }
              ]
            }
          }
        end
        it "returns an error" do
          post_request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body["errors"]).
            to include(
              "Name can't be blank",
              "Workout session exercises sets can't be blank",
              "Workout session exercises reps can't be blank"
            )
        end
      end
    end

    context "when unauthenticated" do
      let(:headers) { nil }

      it "returns unauthorized status" do
        post_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /workout_sessions/:id" do
    let(:params) do
      {
        workout_session: { name: "Updated Session A" }
      }
    end

    let(:put_request) do
      put "/api/v1/workout_sessions/#{workout_session.id}", params: params.to_json, headers: headers
    end

    context "when authenticated" do
      it "updates the workout session" do
        put_request

        expect(response).to have_http_status(:ok)
        expect(response_body["name"]).to eq("Updated Session A")
      end

      context 'with invalid data' do
        let(:params) do
          {
            workout_session: { name: "" }
          }
        end
        it "returns an error for invalid data" do
          put_request

          expect(response).to have_http_status(:unprocessable_entity)
          expect(response_body["errors"]).to include("Name can't be blank")
        end
      end

      context 'when updating sets and reps of an exercise in the workout session' do
        let!(:workout_session_exercise) do
          create(:workout_session_exercise,
                 workout_session: workout_session,
                 exercise: exercise1,
                 sets: 3,
                 reps: 10)
        end

        context 'with correct params' do
          let(:params) do
            {
              workout_session: {
                workout_session_exercises_attributes: [
                  { id: workout_session_exercise.id, sets: 5, reps: 12, technique: 'drop set' }
                ]
              }
            }
          end

          it 'must update the session exercise' do
            put_request
            expect(response).to have_http_status(:ok)
            updated_exercise = response_body["workout_session_exercises"].find { |e| e["id"] == workout_session_exercise.id }
            expect(updated_exercise["sets"]).to eq(5)
            expect(updated_exercise["reps"]).to eq(12)
            expect(updated_exercise["technique"]).to eq('drop set')
          end
        end

        context 'with invalid data' do
          let(:params) do
            {
              workout_session: {
                workout_session_exercises_attributes: [
                  { id: workout_session_exercise.id, sets: -1, reps: -1, technique: 'drop set' }
                ]
              }
            }
          end

          it 'must update the session exercise' do
            put_request
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body["errors"]).to include(
              "Workout session exercises sets must be greater than or equal to 0",
              "Workout session exercises reps must be greater than or equal to 0")
          end
        end

        context 'when trying to update a non existing exercise' do
          let(:params) do
            {
              workout_session: {
                workout_session_exercises_attributes: [
                  { id: 999, sets: -1, reps: -1, technique: 'drop set' }
                ]
              }
            }
          end

          it 'must return an error' do
            put_request
            expect(response).to have_http_status(:not_found)
            expect(response_body["error"]).to eq("Couldn't find WorkoutSessionExercise with ID=999 for WorkoutSession with ID=#{workout_session.id}")
          end
        end
      end
    end

    context "when unauthenticated" do
      let(:headers) { nil }
      it "returns unauthorized status" do
        put_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /workout_sessions/:id" do
    let(:workout_session_id) { workout_session.id }
    let(:delete_request) do
      delete "/api/v1/workout_sessions/#{workout_session_id}", headers: headers
    end

    context "when authenticated" do
      it "deletes the workout session" do
        expect {
          delete_request
        }.to change { WorkoutSession.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end

      context 'with a non-existing workout session' do
        let(:workout_session_id) { 999 }

        it "returns not found" do
          delete_request

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)).to eq({ "error" => "Workout session not found" })
        end
      end
    end

    context "when unauthenticated" do
      let(:headers) { nil }
      it "returns unauthorized status" do
        delete_request

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
