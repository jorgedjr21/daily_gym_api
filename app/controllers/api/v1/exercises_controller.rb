class Api::V1::ExercisesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: %i[show update destroy]

  # GET /exercises
  def index
    exercises = Exercise.all
    render json: exercises, status: :ok
  end

  # GET /exercises/:id
  def show
    render json: @exercise, status: :ok
  end

  # POST /exercises
  def create
    exercise = Exercise.new(exercise_params)

    if exercise.save
      render json: exercise, status: :created
    else
      render json: { errors: exercise.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /exercises/:id
  def update
    if @exercise.update(exercise_params)
      render json: @exercise, status: :ok
    else
      render json: { errors: @exercise.errors.full_messages }, status: :unprocessable_entity
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
