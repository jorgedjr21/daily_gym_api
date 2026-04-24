class WorkoutSessionExerciseBlueprint < Blueprinter::Base
  identifier :id
  fields :exercise_id, :sets, :reps, :technique, :current_weight
end
