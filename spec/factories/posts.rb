# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    post_type 'prose'
    title { Faker::Lorem.words(7).join(' ').titleize }
    slug { title.downcase.gsub!(/\W/, '-') }
    published_at { Time.new }
    body { Faker::Lorem.paragraphs(5).join("\n\n") }
    
    factory :draft_post do
      published_at nil
    end
  end
end
