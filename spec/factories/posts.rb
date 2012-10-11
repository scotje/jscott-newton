# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    post_type 'prose'
    title { Faker::Lorem.words(7).join(' ').titleize }
    slug { title.downcase.gsub!(/\W/, '-') }
    body { Faker::Lorem.paragraphs(5).join("\n\n") }
    
    trait :published do
      published_at { Time.new + Random.rand(-15..15).days }
    end
    
    trait :draft do
      published_at nil
    end
    
    trait :invalid_slug do
      slug "this is an INVALID post slug!"
    end
  end
end
