class Api::V1::WorkoutSessionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workout_session, only: %i[show update destroy]

  # GET /workout_sessions
  def index
    workout_sessions = current_user.workout_sessions.includes(:workout_session_exercises)
    render json: WorkoutSessionBlueprint.render_as_hash(workout_sessions, view: :with_exercises), status: :ok
  end

  # GET /workout_sessions/:id
  def show
    render json: WorkoutSessionBlueprint.render_as_hash(@workout_session, view: :with_exercises), status: :ok
  end

  # POST /workout_sessions
  def create
    workout_session = current_user.workout_sessions.build(workout_session_params)

    if workout_session.save
      render json: WorkoutSessionBlueprint.render_as_hash(workout_session, view: :with_exercises), status: :created
    else
      render json: { errors: workout_session.errors.full_messages }, status: :unprocessable_content
    end
  end

  # PUT /workout_sessions/:id
  def update
    if @workout_session.update(workout_session_params)
      render json: WorkoutSessionBlueprint.render_as_hash(@workout_session, view: :with_exercises), status: :ok
    else
      render json: { errors: @workout_session.errors.full_messages }, status: :unprocessable_content
    end
  end

  # DELETE /workout_sessions/:id
  def destroy
    @workout_session.destroy
    head :no_content
  end

  private

  def set_workout_session
    @workout_session = current_user.workout_sessions.find_by(id: params[:id])
    render json: { error: "Workout session not found" }, status: :not_found unless @workout_session
  end

  def workout_session_params
    params.require(:workout_session).permit(
      :name,
      workout_session_exercises_attributes: %i[id exercise_id sets reps technique current_weight]
    )
  end
end
