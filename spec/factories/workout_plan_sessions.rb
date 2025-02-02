FactoryBot.define do
  factory :workout_plan_session do
    association :workout_plan
    association :workout_session
  end
end
