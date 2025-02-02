class WorkoutSession < ApplicationRecord
  validates :name, presence: true

  belongs_to :user

  has_many :workout_session_exercises, dependent: :destroy
  has_many :exercises, through: :workout_session_exercises
  has_many :workout_plan_sessions, dependent: :destroy
  has_many :workout_plans, through: :workout_plan_sessions

  accepts_nested_attributes_for :workout_session_exercises, allow_destroy: true
end
