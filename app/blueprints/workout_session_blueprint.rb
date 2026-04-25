class WorkoutSessionBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :user_id

  view :with_exercises do
    association :workout_session_exercises, blueprint: WorkoutSessionExerciseBlueprint
  end
end
