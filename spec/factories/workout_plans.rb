FactoryBot.define do
  factory :workout_plan do
    name { "Strength Training Plan" }
    description { "A plan for building strength." }
    association :user

    trait :with_sessions do
      after(:create) do |workout_plan|
        sessions = create_list(:workout_session, 3, user: workout_plan.user)
        sessions.each do |session|
          create(:workout_plan_session, workout_plan: workout_plan, workout_session: session)
        end
      end
    end
  end
end
