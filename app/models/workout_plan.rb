class WorkoutPlan < ApplicationRecord
  belongs_to :user
  has_many :workout_plan_sessions, dependent: :destroy
  has_many :workout_sessions, through: :workout_plan_sessions
  validates :name, presence: true

  # Ensure workout sessions in the plan belong to the same user
  validate :sessions_belong_to_user

  private

  def sessions_belong_to_user
    workout_sessions.each do |session|
      if session.user_id != user_id
        errors.add(:workout_sessions, "must belong to the same user as the workout plan")
      end
    end
  end
end
