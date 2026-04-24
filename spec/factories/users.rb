FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { 'passoword1234' }
    password_confirmation { password }

    trait :admin do
      role { 'admin' }
    end
  end
end
