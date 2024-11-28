FactoryBot.define do
  factory :workout_session do
    name { "Session A" }
    association :workout_plan
  end
end
