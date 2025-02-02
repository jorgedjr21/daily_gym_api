FactoryBot.define do
  factory :workout_plan do
    name { "Strength Training Plan" }
    description { "A plan for building strength." }

    association :user

    after(:create) do |workout_plan, evaluator|
      create_list(:workout_session, 6).each do |workout_session|
        create(:workout_plan_session, workout_plan: workout_plan, workout_session: workout_session)
      end
    end
  end
end
