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

ActiveRecord::Schema.define(version: 20150816220153) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_variants", force: true do |t|
    t.integer  "product_id",                            null: false
    t.boolean  "is_default",                            null: false
    t.string   "name",                                  null: false
    t.decimal  "price",        precision: 10, scale: 2
    t.string   "sku"
    t.string   "condition"
    t.boolean  "availability"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name",                                       null: false
    t.string   "short_description"
    t.text     "description"
    t.decimal  "price",             precision: 10, scale: 2
    t.string   "sku"
    t.integer  "stock_quantity"
    t.integer  "user_id"
    t.string   "condition"
    t.text     "note"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["sku"], name: "index_products_on_sku"

  create_table "products_categories", force: true do |t|
    t.integer  "product_id",  null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products_categories", ["product_id", "category_id"], name: "index_products_categories_on_product_id_and_category_id", unique: true

end
