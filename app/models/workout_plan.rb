class WorkoutPlan < ApplicationRecord
  validates :name, presence: true

  has_many :workout_sessions, dependent: :destroy
end
