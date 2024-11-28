class Exercise < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :workout_session_exercises
  has_many :workout_sessions, through: :workout_session_exercises
end
