class SetDefaultRoleOnUsers < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE users SET role = 'member' WHERE role IS NULL"

    change_column_default :users, :role, from: nil, to: 'member'
    change_column_null :users, :role, false
  end

  def down
    change_column_null :users, :role, true
    change_column_default :users, :role, from: 'member', to: nil
  end
end
