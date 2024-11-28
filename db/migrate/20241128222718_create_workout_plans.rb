class CreateWorkoutPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :workout_plans do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
