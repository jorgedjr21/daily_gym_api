FactoryBot.define do
  factory :workout_session_exercise do
    association :workout_session
    association :exercise
    sets { 3 }
    reps { 10 }
    technique { "drop set" }
    current_weight { 30.0 }
  end
end
