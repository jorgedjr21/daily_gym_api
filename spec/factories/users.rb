FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'passoword1234' }
  end
end
