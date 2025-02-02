FactoryBot.define do
  factory :workout_session do
    name { "Session A" }
    association :user
  end
end
