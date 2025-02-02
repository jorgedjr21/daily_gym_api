# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_02_02_023551) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_exercises_on_name", unique: true
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "jti"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_blacklists_on_jti"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workout_plan_sessions", force: :cascade do |t|
    t.bigint "workout_plan_id", null: false
    t.bigint "workout_session_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workout_plan_id", "workout_session_id"], name: "index_workout_plan_sessions_on_plan_id_and_session_id", unique: true
    t.index ["workout_plan_id"], name: "index_workout_plan_sessions_on_workout_plan_id"
    t.index ["workout_session_id", "workout_plan_id"], name: "index_workout_session_plans_on_session_id_and_plan_id", unique: true
    t.index ["workout_session_id"], name: "index_workout_plan_sessions_on_workout_session_id"
  end

  create_table "workout_plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_workout_plans_on_user_id"
  end

  create_table "workout_session_exercises", force: :cascade do |t|
    t.bigint "workout_session_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "sets"
    t.integer "reps"
    t.string "technique"
    t.decimal "current_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_workout_session_exercises_on_exercise_id"
    t.index ["workout_session_id"], name: "index_workout_session_exercises_on_workout_session_id"
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.string "name"
    t.bigint "workout_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
    t.index ["workout_plan_id"], name: "index_workout_sessions_on_workout_plan_id"
  end

  add_foreign_key "workout_plan_sessions", "workout_plans"
  add_foreign_key "workout_plan_sessions", "workout_sessions"
  add_foreign_key "workout_plans", "users"
  add_foreign_key "workout_session_exercises", "exercises"
  add_foreign_key "workout_session_exercises", "workout_sessions"
  add_foreign_key "workout_sessions", "users"
  add_foreign_key "workout_sessions", "workout_plans"
end
