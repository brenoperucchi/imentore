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

ActiveRecord::Schema.define(version: 20151114081822) do

  create_table "imentore_addresses", force: true do |t|
    t.string  "name"
    t.string  "street"
    t.string  "complement"
    t.string  "city"
    t.string  "state"
    t.string  "country"
    t.string  "zip_code"
    t.string  "phone"
    t.integer "addressable_id"
    t.string  "addressable_type"
  end

  create_table "imentore_asset_folders", force: true do |t|
    t.string   "name"
    t.integer  "asset_id"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imentore_assets", force: true do |t|
    t.string   "file"
    t.integer  "theme_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imentore_carts", force: true do |t|
    t.text "items"
  end

  create_table "imentore_domains", force: true do |t|
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imentore_employees", force: true do |t|
    t.string   "name"
    t.string   "brand"
    t.string   "irs_id"
    t.date     "birthdate"
    t.string   "national_id"
    t.string   "gender"
    t.string   "person_type"
    t.integer  "store_id"
    t.string   "department"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
    t.text    "shipping_address"
    t.text    "billing_address"
    t.decimal "total_amount"
    t.string  "status"
    t.string  "customer_email"
    t.text    "items"
    t.integer "invoice_id"
    t.integer "delivery_id"
    t.integer "store_id"
  end

  create_table "imentore_product_variants", force: true do |t|
    t.decimal "price"
    t.integer "quantity"
    t.string  "sku"
    t.decimal "weight"
    t.decimal "height"
    t.decimal "width"
    t.decimal "depth"
    t.boolean "shippable"
    t.integer "product_id"
  end

  create_table "imentore_products", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "permalink"
    t.integer  "store_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
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
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "config"
  end

  create_table "imentore_templates", force: true do |t|
    t.string   "path"
    t.text     "body"
    t.boolean  "partial",    default: false
    t.string   "layout"
    t.string   "format",     default: "text/html"
    t.string   "locale",     default: "en"
    t.string   "handler",    default: "liquid"
    t.integer  "theme_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "header"
    t.text     "head"
  end

  create_table "imentore_themes", force: true do |t|
    t.string  "name"
    t.integer "store_id"
    t.boolean "default",  default: false
  end

  create_table "imentore_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "store_id"
    t.integer  "userable_id"
    t.string   "userable_type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

end
