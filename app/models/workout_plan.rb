class WorkoutPlan < ApplicationRecord
  belongs_to :user
  validates :name, presence: true

  has_many :workout_sessions, dependent: :destroy

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
