FactoryBot.define do
  factory :exercise do
    sequence(:name) { |n| "Exercise #{n}" }
    description { "A basic bodyweight exercise." }
  end
end
