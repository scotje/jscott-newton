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
    
    trait :body_with_fenced_code_block do
      body do
        sample = Faker::Lorem.paragraphs(3).join("\n\n") + "\n\n"
        sample += <<-END.gsub(/^ {10}/, '')
          ``` ruby
          require 'redcarpet'
          markdown = Redcarpet.new("Hello World!")
          puts markdown.to_html
          !-- Code caption.
          ```
        END
        sample += "\n\n" + Faker::Lorem.paragraphs(2).join("\n\n")
      end
    end
    
    trait :body_with_blockquote do
      body do
        sample = Faker::Lorem.paragraphs(3).join("\n\n") + "\n\n"
        sample += <<-END.gsub(/^ {10}/, '')
          > This is something that I never said!
          > 
          > --Abraham Lincoln
        END
        sample += "\n\n" + Faker::Lorem.paragraphs(2).join("\n\n")
      end
    end
    
    trait :body_with_image do
      body do
        sample = Faker::Lorem.paragraphs(3).join("\n\n") + "\n\n"
        sample += "[![](http://example.com/test.jpg \"This is a caption!\")](http://example.com/test/)"
        sample += "\n\n" + Faker::Lorem.paragraphs(2).join("\n\n")
      end
    end
  end
end
