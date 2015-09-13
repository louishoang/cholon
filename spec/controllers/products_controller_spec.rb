require "rails_helper"

RSpec.describe ProductsController, :type => :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
  end


  describe "post to #create WITHOUT params has variant" do
    it "creates variant and redirect to upload photo page" do
      expect do
        post :create, product: FactoryGirl.build(:product, user_id: @user.id).attributes, format: :json
      end.to change(Product, :count).by(1)

      variant = ProductVariant.last
      expect(variant.product_id).to eql(assigns(:product).id)
      expect(response.body).to include("product_photos/new")
    end
  end

  describe "post to #create WITH has_variant param" do
    it "creates variant and redirect to create variants page" do
      expect do
        post :create, product: FactoryGirl.build(:product, user_id: @user.id).attributes, format: :json, has_variants: true
      end.to change(Product, :count).by(1)

      expect(response.body).to include("create_variants")
    end
  end
end