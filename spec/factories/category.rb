FactoryGirl.define do
  factory :category do
    name { FactoryGirl.generate(:name) }
  end
end