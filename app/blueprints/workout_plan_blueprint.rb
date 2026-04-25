class WorkoutPlanBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :description, :user_id

  view :with_sessions do
    association :workout_sessions, blueprint: WorkoutSessionBlueprint, view: :with_exercises
  end
end
