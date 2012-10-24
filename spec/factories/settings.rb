# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |n| "#{Faker::Lorem.word}#{n}.#{Faker::Lorem.words(2).join('.')}" }
    setting_type 'string'
    value { Faker::Lorem.words(5).join(' ') }
    system true

    trait :user_setting do
      system false
    end
    
    trait :invalid_key do
      key "this is an invalid key"
    end
  end
end
