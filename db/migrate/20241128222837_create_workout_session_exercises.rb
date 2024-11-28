class CreateWorkoutSessionExercises < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_session_exercises do |t|
      t.references :workout_session, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :sets
      t.integer :reps
      t.string :technique
      t.decimal :current_weight

      t.timestamps
    end
  end
end
