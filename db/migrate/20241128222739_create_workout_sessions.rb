class CreateWorkoutSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_sessions do |t|
      t.string :name

      t.timestamps
    end
  end
end
