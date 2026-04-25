class Api::V1::ExercisesController < ApplicationController
  include Authorizable
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[show update destroy]
  before_action :require_admin!, only: %i[create update destroy]

  # GET /exercises
  def index
    exercises = Exercise.all
    exercises = exercises.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
    pagy, records = pagy(exercises, limit: params.fetch(:per_page, 20).to_i)
    render json: {
      data: ExerciseBlueprint.render_as_hash(records),
      pagination: pagy_metadata(pagy)
    }, status: :ok
  end

  # GET /exercises/:id
  def show
    render json: ExerciseBlueprint.render_as_hash(@exercise), status: :ok
  end

  # POST /exercises
  def create
    exercise = Exercise.new(exercise_params)

    if exercise.save
      render json: ExerciseBlueprint.render_as_hash(exercise), status: :created
    else
      render json: { errors: exercise.errors.full_messages }, status: :unprocessable_content
    end
  end

  # PUT /exercises/:id
  def update
    if @exercise.update(exercise_params)
      render json: ExerciseBlueprint.render_as_hash(@exercise), status: :ok
    else
      render json: { errors: @exercise.errors.full_messages }, status: :unprocessable_content
    end
  end

  # DELETE /exercises/:id
  def destroy
    @exercise.destroy
    head :no_content
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Exercise not found" }, status: :not_found
  end

  def exercise_params
    params.require(:exercise).permit(:name, :description)
  end
end
