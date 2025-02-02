class WorkoutPlanSession < ApplicationRecord
  belongs_to :workout_plan
  belongs_to :workout_session
end
