# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    sequence(:url) { |n| "https://www.flipkart.com/sample-product-#{n}" }
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price }
    brand { Faker::Company.name }
    status { 'pending' }
    
    trait :completed do
      status { 'completed' }
      last_scraped_at { Time.current }
    end
    
    trait :failed do
      status { 'failed' }
      error_message { "Failed to scrape: Network error" }
    end
  end
end