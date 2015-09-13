FactoryGirl.define do
  factory :product do
    name Faker::Commerce.product_name
    description Faker::Lorem.paragraph(2)
    price Faker::Commerce.price
    stock_quantity Faker::Number.between(1, 100)
    condition ["New", "Used", "Refurbished", "For Part or Not Working"].sample

    user
    
    after(:create) do |product|
      FactoryGirl.create(:product_variant, :product => product)
    end

  end
end