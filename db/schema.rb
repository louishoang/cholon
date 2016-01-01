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

ActiveRecord::Schema.define(version: 20151231235221) do

  create_table "addresses", force: :cascade do |t|
    t.string   "first_name",    limit: 255, null: false
    t.string   "last_name",     limit: 255, null: false
    t.string   "business_name", limit: 255
    t.string   "address1",      limit: 255, null: false
    t.string   "address2",      limit: 255
    t.string   "city",          limit: 255, null: false
    t.string   "state",         limit: 255, null: false
    t.string   "zip_code",      limit: 255, null: false
    t.string   "phone",         limit: 255
    t.string   "email",         limit: 255
    t.string   "address_type",  limit: 255
    t.integer  "order_id",      limit: 4,   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer  "product_id",         limit: 4,                          null: false
    t.integer  "order_id",           limit: 4,                          null: false
    t.decimal  "unit_price",                   precision: 10, scale: 2, null: false
    t.integer  "quantity",           limit: 4
    t.decimal  "total_price",                  precision: 10, scale: 2
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "seller_id",          limit: 4,                          null: false
    t.integer  "product_variant_id", limit: 4,                          null: false
  end

  add_index "order_items", ["product_id", "order_id"], name: "index_order_items_on_product_id_and_order_id", unique: true, using: :btree
  add_index "order_items", ["product_id"], name: "index_order_items_on_product_id", using: :btree
  add_index "order_items", ["product_variant_id", "order_id"], name: "index_order_items_on_product_variant_id_and_order_id", unique: true, using: :btree
  add_index "order_items", ["seller_id"], name: "index_order_items_on_seller_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.decimal  "subtotal",                 precision: 10, scale: 2
    t.decimal  "tax",                      precision: 10, scale: 2
    t.decimal  "total",                    precision: 10, scale: 2
    t.integer  "status",         limit: 4,                          default: 0
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "user_id",        limit: 4,                                      null: false
    t.decimal  "shipping_price",           precision: 8,  scale: 2
  end

  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "product_categories", force: :cascade do |t|
    t.integer  "product_id",  limit: 4
    t.integer  "category_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_categories", ["product_id", "category_id"], name: "index_product_categories_on_product_id_and_category_id", unique: true, using: :btree

  create_table "product_option_values", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.integer  "product_option_id", limit: 4,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "product_options", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "popularity", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "product_photos", force: :cascade do |t|
    t.integer  "product_variant_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size",    limit: 4
    t.datetime "photo_updated_at"
  end

  add_index "product_photos", ["product_variant_id"], name: "index_product_photos_on_product_variant_id", using: :btree

  create_table "product_variants", force: :cascade do |t|
    t.integer  "product_id",     limit: 4,                                            null: false
    t.string   "name",           limit: 255,                                          null: false
    t.decimal  "price",                      precision: 10, scale: 2
    t.string   "sku",            limit: 255
    t.integer  "stock_quantity", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default",                                          default: false
  end

  add_index "product_variants", ["is_default"], name: "index_product_variants_on_is_default", using: :btree
  add_index "product_variants", ["product_id"], name: "index_product_variants_on_product_id", using: :btree
  add_index "product_variants", ["sku"], name: "index_product_variants_on_sku", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "name",             limit: 255,                            null: false
    t.text     "description",      limit: 65535
    t.decimal  "price",                          precision: 10, scale: 2
    t.string   "sku",              limit: 255
    t.integer  "stock_quantity",   limit: 4
    t.integer  "seller_id",        limit: 4
    t.integer  "condition",        limit: 4
    t.string   "location",         limit: 255
    t.string   "slug",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",           limit: 4
    t.integer  "shipping_method",  limit: 4
    t.decimal  "shipping_price",                 precision: 10, scale: 2
    t.float    "latitude",         limit: 24
    t.float    "longitude",        limit: 24
    t.integer  "shipping_carrier", limit: 4
    t.decimal  "weight",                         precision: 10, scale: 2
    t.string   "length",           limit: 255
    t.string   "width",            limit: 255
    t.string   "height",           limit: 255
    t.string   "city",             limit: 255
    t.string   "state",            limit: 255
  end

  add_index "products", ["city"], name: "index_products_on_city", using: :btree
  add_index "products", ["condition"], name: "index_products_on_condition", using: :btree
  add_index "products", ["seller_id"], name: "index_products_on_seller_id", using: :btree
  add_index "products", ["shipping_carrier"], name: "index_products_on_shipping_carrier", using: :btree
  add_index "products", ["sku"], name: "index_products_on_sku", using: :btree
  add_index "products", ["slug"], name: "index_products_on_slug", using: :btree
  add_index "products", ["state"], name: "index_products_on_state", using: :btree
  add_index "products", ["status"], name: "index_products_on_status", using: :btree

  create_table "shipping_speeds", force: :cascade do |t|
    t.string   "name",          limit: 255,                                           null: false
    t.string   "carrier",       limit: 255,                                           null: false
    t.decimal  "price",                       precision: 8, scale: 2,                 null: false
    t.text     "timeframe",     limit: 65535
    t.integer  "order_item_id", limit: 4,                                             null: false
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.boolean  "selected",                                            default: false
  end

  create_table "states", force: :cascade do |t|
    t.string   "abbreviation", limit: 255
    t.string   "name",         limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        limit: 4,     default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.text     "avatar_url",             limit: 65535
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "variant_option_values", force: :cascade do |t|
    t.integer  "product_option_value_id", limit: 4, null: false
    t.integer  "product_variant_id",      limit: 4, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "variant_option_values", ["product_variant_id", "product_option_value_id"], name: "variant_option_values_index", using: :btree

end
