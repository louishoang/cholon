require "rails_helper"

RSpec.describe ProductsController, :type => :controller do
  before do
    login_user
  end
  
  describe "post to #create" do
    context "WITHOUT params has variant" do
      it "creates variant and redirect to upload photo page" do
        expect do
          post :create, product: FactoryGirl.build(:product, seller_id: @user.id).attributes, format: :json
        end.to change(Product, :count).by(1)

        variant = ProductVariant.last
        expect(variant.product_id).to eql(assigns(:product).id)
        expect(response.body).to include("product_photos/new")
      end
    end

    context "WITH has_variant param" do
      it "creates variant and redirect to create variants page" do
        expect do
          post :create, product: FactoryGirl.build(:product, seller_id: @user.id).attributes, format: :json, has_variants: true
        end.to change(Product, :count).by(1)

        expect(response.body).to include("create_variants")
      end
    end

    context "with invalid product params" do
      it "doesn't create variant and return errors" do
        expect do
          post :create, product: {name: "Invalid", seller_id: @user.id}, format: :json
        end.not_to change{Product.count}

        expect(response.body).to include("message")
        expect(assigns(:product).errors.messages.size).to be >= 1
      end
    end

    context "with params page_is_dirty" do
      it "update the record instead of creating new" do
        product = FactoryGirl.create(:product, seller_id: @user.id)
        request.cookies['product_slug'] = product.slug

        expect do
          post :create, product: product.attributes, format: :json, page_is_dirty: '1'
        end.not_to change{Product.count}

        expect(response.body).to include("product_photos/new")
        expect(assigns(:product).product_variants.size).to eql(1)
      end
    end
  end
end