class CreateExercises < ActiveRecord::Migration[7.2]
  def change
    create_table :exercises do |t|
      t.string :name
      t.text :description

      t.timestamps
    end

    add_index :exercises, :name, unique: true
  end
end
