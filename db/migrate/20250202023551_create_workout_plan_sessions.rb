class CreateWorkoutPlanSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_plan_sessions do |t|
      t.references :workout_plan, null: false, foreign_key: true
      t.references :workout_session, null: false, foreign_key: true
      t.timestamps
    end

    add_index :workout_plan_sessions, [ :workout_plan_id, :workout_session_id ], unique: true, name: 'index_workout_plan_sessions_on_plan_id_and_session_id'
    add_index :workout_plan_sessions, [ :workout_session_id, :workout_plan_id ], unique: true, name: 'index_workout_session_plans_on_session_id_and_plan_id'
  end
end
