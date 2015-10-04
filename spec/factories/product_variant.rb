FactoryGirl.define do
  factory :product_variant do
    name Faker::Commerce.color
    price Faker::Commerce.price
    stock_quantity Faker::Number.between(1, 100)
    is_default false

    after(:create) do |variant|
      FactoryGirl.create(:product_photo, :product_variant => variant)
    end
  end
end