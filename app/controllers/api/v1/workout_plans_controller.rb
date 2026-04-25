class Api::V1::WorkoutPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_plan, only: %i[show update destroy]

  def index
    workout_plans = current_user.workout_plans
    render json: WorkoutPlanBlueprint.render_as_hash(workout_plans, view: :with_sessions), status: :ok
  end

  def show
    render json: WorkoutPlanBlueprint.render_as_hash(@workout_plan, view: :with_sessions), status: :ok
  end

  def create
    workout_plan = current_user.workout_plans.build(workout_plan_params)

    if workout_plan.save
      render json: WorkoutPlanBlueprint.render_as_hash(workout_plan, view: :with_sessions), status: :created
    else
      render json: { errors: workout_plan.errors.full_messages }, status: :unprocessable_content
    end
  end

  def update
    if @workout_plan.update(workout_plan_params)
      render json: WorkoutPlanBlueprint.render_as_hash(@workout_plan, view: :with_sessions), status: :ok
    else
      render json: { errors: @workout_plan.errors.full_messages }, status: :unprocessable_content
    end
  end

  def destroy
    @workout_plan.destroy
    head :no_content
  end

  private

  def set_workout_plan
    @workout_plan = current_user.workout_plans.find_by(id: params[:id])
    render json: { error: "Workout plan not found" }, status: :not_found unless @workout_plan
  end

  def workout_plan_params
    params.require(:workout_plan).permit(:name, :description, workout_session_ids: [])
  end
end
