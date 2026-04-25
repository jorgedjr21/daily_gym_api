class UserBlueprint < Blueprinter::Base
  identifier :id
  fields :name, :email, :role

  view :minimal do
    excludes :role
  end
end
