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

ActiveRecord::Schema.define(version: 20120424115236) do

  create_table "imentore_carts", force: true do |t|
    t.text "items"
  end

  create_table "imentore_deliveries", force: true do |t|
    t.integer "order_id"
    t.text    "address"
    t.string  "tracking_code"
    t.string  "status"
    t.integer "delivery_method_id"
  end

  create_table "imentore_delivery_methods", force: true do |t|
    t.string  "name"
    t.integer "store_id"
    t.string  "handle"
    t.text    "options"
    t.boolean "active",     default: false
    t.string  "calculator"
  end

  create_table "imentore_domains", force: true do |t|
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hosting",    default: false
    t.integer  "plesk_id"
    t.text     "emails"
  end

  create_table "imentore_employees", force: true do |t|
    t.string  "name"
    t.string  "brand"
    t.string  "irs_id"
    t.date    "birthdate"
    t.string  "national_id"
    t.string  "gender"
    t.string  "person_type"
    t.integer "store_id"
    t.string  "department"
  end

  create_table "imentore_images", force: true do |t|
    t.string   "picture"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imentore_invoices", force: true do |t|
    t.integer  "order_id"
    t.string   "provider_id"
    t.integer  "payment_method_id"
    t.string   "status"
    t.decimal  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imentore_option_types", force: true do |t|
    t.string  "name"
    t.string  "handle"
    t.integer "product_id"
  end

  create_table "imentore_option_values", force: true do |t|
    t.integer "option_type_id"
    t.integer "product_variant_id"
    t.string  "value"
  end

  create_table "imentore_orders", force: true do |t|
    t.text     "shipping_address"
    t.text     "billing_address"
    t.string   "status"
    t.string   "customer_email"
    t.text     "items"
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imentore_payment_methods", force: true do |t|
    t.string  "name"
    t.string  "handle"
    t.text    "options"
    t.integer "store_id"
    t.boolean "active",   default: false
  end

  create_table "imentore_product_variants", force: true do |t|
    t.decimal "price"
    t.integer "quantity"
    t.string  "sku"
    t.decimal "weight"
    t.decimal "height"
    t.decimal "width"
    t.decimal "depth"
    t.boolean "deliverable"
    t.integer "product_id"
  end

  create_table "imentore_products", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.string  "permalink"
    t.integer "store_id"
  end

  create_table "imentore_stores", force: true do |t|
    t.string   "name"
    t.string   "brand"
    t.string   "url"
    t.string   "irs_id"
    t.boolean  "active",                default: false
    t.text     "settings"
    t.string   "national_id"
    t.string   "date_initial_business"
    t.string   "where_meet_us"
    t.string   "email"
    t.string   "store_type"
    t.integer  "plan_id"
    t.integer  "user_agent_id"
    t.string   "state",                 default: "pending"
    t.datetime "disabled_at"
    t.datetime "actived_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "config"
  end

end
