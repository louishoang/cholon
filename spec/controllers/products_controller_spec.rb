require "rails_helper"

RSpec.describe ProductsController, :type => :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryGirl.create(:user)
    @user.confirm!
    sign_in @user
  end


  describe "POST create without params has variant" do
    it "create variant and redirect to upload photo page" do
      # product = FactoryGirl.build(:product, user_id: @user.id)
      expect do
        post :create, product: FactoryGirl.build(:product, user_id: @user.id).attributes, format: :json
      end.to change(Product, :count).by(1)

      variant = ProductVariant.last
      expect(variant.product_id).to eql(assigns(:product).id)
    end
  end
end