FactoryGirl.define do
  factory :product do
    name Faker::Commerce.product_name
    description Faker::Lorem.paragraph(2)
    price Faker::Commerce.price
    stock_quantity Faker::Number.between(1, 100)
    condition ["New", "Used", "Refurbished", "For Part or Not Working"].sample

    seller
    
    after(:create) do |product|
      FactoryGirl.create(:product_variant, :product => product)
    end

    trait :draft do
      status Product.statuses[:draft]
    end

    trait :publishable do
      status Product.statuses[:publishable]
    end

  end
end