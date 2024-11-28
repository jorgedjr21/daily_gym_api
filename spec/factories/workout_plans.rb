FactoryBot.define do
  factory :workout_plan do
    name { "Strength Training Plan" }
    description { "A plan for building strength." }

    association :user
  end
end
