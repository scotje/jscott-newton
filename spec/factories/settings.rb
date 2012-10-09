# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    sequence(:key) { |n| "#{Faker::Lorem.words(3).join('-')}-#{n}" }
    setting_type 'string'
    value { Faker::Lorem.words(5).join(' ') }
    system true

    factory :user_setting do
      system false
    end
  end
end
