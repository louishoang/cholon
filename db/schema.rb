# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151009183157) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "product_categories", force: true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_categories", ["product_id", "category_id"], name: "index_product_categories_on_product_id_and_category_id", unique: true, using: :btree

  create_table "product_photos", force: true do |t|
    t.integer  "product_variant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "product_photos", ["product_variant_id"], name: "index_product_photos_on_product_variant_id", using: :btree

  create_table "product_variants", force: true do |t|
    t.integer  "product_id",                                              null: false
    t.string   "name",                                                    null: false
    t.decimal  "price",          precision: 10, scale: 2
    t.string   "sku"
    t.integer  "stock_quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default",                              default: false
  end

  add_index "product_variants", ["is_default"], name: "index_product_variants_on_is_default", using: :btree
  add_index "product_variants", ["product_id"], name: "index_product_variants_on_product_id", using: :btree
  add_index "product_variants", ["sku"], name: "index_product_variants_on_sku", using: :btree

  create_table "products", force: true do |t|
    t.string   "name",                                                 null: false
    t.text     "description"
    t.decimal  "price",                       precision: 10, scale: 2
    t.string   "sku"
    t.integer  "stock_quantity"
    t.integer  "seller_id"
    t.string   "condition"
    t.string   "location"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "shipping_method"
    t.decimal  "shipping_price",              precision: 10, scale: 2
    t.float    "latitude",         limit: 24
    t.float    "longitude",        limit: 24
    t.string   "shipping_carrier"
    t.decimal  "weight",                      precision: 10, scale: 2
    t.string   "length"
    t.string   "width"
    t.string   "height"
    t.string   "city"
    t.string   "state"
  end

  add_index "products", ["city"], name: "index_products_on_city", using: :btree
  add_index "products", ["condition"], name: "index_products_on_condition", using: :btree
  add_index "products", ["seller_id"], name: "index_products_on_seller_id", using: :btree
  add_index "products", ["shipping_carrier"], name: "index_products_on_shipping_carrier", using: :btree
  add_index "products", ["sku"], name: "index_products_on_sku", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", using: :btree
  add_index "products", ["state"], name: "index_products_on_state", using: :btree
  add_index "products", ["status"], name: "index_products_on_status", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "provider"
    t.string   "uid"
    t.text     "avatar_url"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
