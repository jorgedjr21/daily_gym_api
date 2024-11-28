class WorkoutSessionExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise

  validates :sets, :reps, presence: true
  validates :current_weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
