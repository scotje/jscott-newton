# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title { Faker::Lorem.words(7).join(' ').titleize }
    slug { title.downcase.gsub!(/\W/, '-') }
    published_at { Time.new }
    body { Faker::Lorem.paragraphs(5).join("\n\n") }
  end
end
