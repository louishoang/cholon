FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer] do
    email Faker::Internet.email
    avatar_url Faker::Avatar.image("my-own-slug", "50x50")
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    password "password"
    password_confirmation "password"
    confirmed_at Time.now
  end
end