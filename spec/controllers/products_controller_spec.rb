require "rails_helper"

RSpec.describe ProductsController, :type => :controller do
  before do
    login_user
  end

  describe "post to #set_publishable" do
    context "when product has photo" do
      it "changes status of product to publishable and redirects to products path" do
        product = FactoryGirl.create(:product, :draft, seller_id: @user.id)
        product_variant = product.product_variants.first
        
        post :set_publishable, product_variant_id: product_variant.id, format: :json
        expect(response.body).to include("/products?")
        expect(response.body).to include("location")
        expect(assigns(:product).status).to eq(Product::STATUS_PUBLISHABLE)
      end
    end

    context "when product has no photo" do
      it "changes status of product and fails valiation" do
        product = FactoryGirl.create(:product, :draft, seller_id: @user.id)
        product_variant = product.product_variants.first
        product_variant.product_photos.destroy_all
        
        post :set_publishable, product_variant_id: product_variant.id, format: :json
        
        expect(response.code).to eq("422")
        expect(response.body).to include("message")
        expect(assigns(:product).status).to eq(Product::STATUS_PUBLISHABLE)
      end
    end
  end

  describe "put to #update" do
    context "create variants" do
      it "creates variants successfully with product_photos" do
        product = FactoryGirl.create(:product, :draft, seller_id: @user.id)
        product.product_variants.destroy_all
        product.reload

        product_variant1 = FactoryGirl.create(:product_variant, product_id: product.id)
        product_variant2 = FactoryGirl.create(:product_variant, product_id: product.id)
        product_photo1 = product_variant1.product_photos.first
        product_photo2 = product_variant2.product_photos.first

        put :update, "product"=>{"product_variants_attributes"=>{
          "0"=>{"product_photo_ids"=> product_photo1.id.to_s.split(""), "name"=>"red", "price"=>"1", "stock_quantity"=>"1"},
          "1"=>{"product_photo_ids"=> product_photo2.id.to_s.split(""), "name"=>"blue", "price"=>"1", "stock_quantity"=>"1"}
          }}, "commit"=>"Lưu Lại & Tiếp Tục", "locale"=>"vi_VN", "id"=> product.slug, format: :json

        expect(assigns(:product).status) == Product::STATUS_PUBLISHABLE
        expect(assigns(:product).product_variants.size).to eq(4)
        expect(assigns(:product).product_variants.last.product_photos.size).to eq(1)
      end
    end
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
          post :create, product: FactoryGirl.build(:product, seller_id: @user.id).attributes, format: :json, has_variants: "true"
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