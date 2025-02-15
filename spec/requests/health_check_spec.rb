require 'rails_helper'

RSpec.describe "HealthChecks", type: :request do
  describe "GET /health_check" do
    it "returns http success" do
      get "/health_check"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({
        "status" => "ok",
        "version" => DailyGymApi::VERSION
        }
      )
    end
  end
end
