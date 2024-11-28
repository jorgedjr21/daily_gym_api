class WorkoutSession < ApplicationRecord
  validates :name, presence: true

  belongs_to :workout_plan
  has_many :workout_session_exercises, dependent: :destroy
  has_many :exercises, through: :workout_session_exercises
end
