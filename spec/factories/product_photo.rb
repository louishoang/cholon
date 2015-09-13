FactoryGirl.define do
  factory :product_photo do
    photo  avatar { fixture_file_upload(Rails.root.join('spec', 'photos', 'backpack.jpeg'), 'image/jpeg') }
  end
end