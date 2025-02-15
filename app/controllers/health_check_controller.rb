class HealthCheckController < ApplicationController
  def index
    render json: { status: "ok", version: DailyGymApi::VERSION }
  end
end
