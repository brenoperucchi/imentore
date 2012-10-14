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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121011184404) do

  create_table "admin_imentore_assets", :force => true do |t|
    t.string   "file"
    t.integer  "theme_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_imentore_send_emails", :force => true do |t|
    t.boolean  "active"
    t.string   "name"
    t.string   "subject"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_imentore_templates", :force => true do |t|
    t.string   "layout"
    t.string   "path"
    t.string   "kind"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "theme_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "admin_imentore_themes", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "active"
    t.string   "used_for"
  end

  create_table "imentore_addresses", :force => true do |t|
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

  create_table "imentore_assets", :force => true do |t|
    t.string   "file"
    t.integer  "theme_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "imentore_carts", :force => true do |t|
    t.text "items"
  end

  create_table "imentore_categories", :force => true do |t|
    t.string   "name"
    t.string   "handle"
    t.integer  "store_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "ancestry"
    t.integer  "ancestry_depth", :default => 0
  end

  add_index "imentore_categories", ["ancestry"], :name => "index_imentore_categories_on_ancestry"

  create_table "imentore_categories_products", :force => true do |t|
    t.integer "product_id"
    t.integer "category_id"
  end

  create_table "imentore_coupons", :force => true do |t|
    t.boolean  "active"
    t.string   "name"
    t.string   "code"
    t.float    "value"
    t.integer  "store_id"
    t.integer  "limit_customer"
    t.integer  "limit_use"
    t.datetime "due_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "imentore_coupons_orders", :force => true do |t|
    t.string  "email"
    t.integer "coupon_id"
    t.integer "cart_id"
    t.integer "order_id"
    t.integer "user_id"
    t.integer "store_id"
  end

  create_table "imentore_customers", :force => true do |t|
    t.string   "name"
    t.string   "brand"
    t.string   "irs_id"
    t.date     "birthdate"
    t.string   "national_id"
    t.string   "gender"
    t.string   "person_type"
    t.integer  "store_id"
    t.string   "department"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "active",      :default => true
  end

  create_table "imentore_deliveries", :force => true do |t|
    t.integer "order_id"
    t.text    "address"
    t.string  "tracking_code"
    t.string  "status"
    t.integer "delivery_method_id"
  end

  create_table "imentore_delivery_methods", :force => true do |t|
    t.string  "name"
    t.integer "store_id"
    t.string  "handle"
    t.text    "options"
    t.boolean "active",      :default => false
    t.string  "calculator"
    t.text    "description"
  end

  create_table "imentore_domains", :force => true do |t|
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "hosting",    :default => false
    t.integer  "plesk_id"
    t.text     "emails"
  end

  create_table "imentore_employees", :force => true do |t|
    t.string   "name"
    t.string   "brand"
    t.string   "irs_id"
    t.date     "birthdate"
    t.string   "national_id"
    t.string   "gender"
    t.string   "person_type"
    t.integer  "store_id"
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      :default => true
  end

  create_table "imentore_feedbacks", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "subject"
    t.text     "question"
    t.text     "answer"
    t.integer  "feedbackable_id"
    t.string   "feedbackable_type"
    t.integer  "user_id"
    t.integer  "store_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "imentore_images", :force => true do |t|
    t.string   "picture"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "imentore_invoices", :force => true do |t|
    t.integer  "order_id"
    t.string   "provider_id"
    t.integer  "payment_method_id"
    t.string   "status"
    t.decimal  "amount",            :precision => 10, :scale => 0
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  create_table "imentore_notices", :force => true do |t|
    t.boolean  "active"
    t.string   "name"
    t.string   "handle"
    t.text     "body"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "imentore_option_types", :force => true do |t|
    t.string  "name"
    t.string  "handle"
    t.integer "product_id"
  end

  create_table "imentore_option_values", :force => true do |t|
    t.integer "option_type_id"
    t.integer "product_variant_id"
    t.string  "value"
  end

  create_table "imentore_order_assets", :force => true do |t|
    t.string   "file"
    t.integer  "assetable_id"
    t.string   "assetable_type"
    t.integer  "store_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "imentore_orders", :force => true do |t|
    t.text     "shipping_address"
    t.text     "billing_address"
    t.string   "status"
    t.string   "customer_email"
    t.text     "items"
    t.integer  "store_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "user_id"
    t.string   "customer_name"
  end

  create_table "imentore_pages", :force => true do |t|
    t.boolean  "active"
    t.string   "name"
    t.string   "handle"
    t.text     "body"
    t.text     "html"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "imentore_payment_methods", :force => true do |t|
    t.string  "name"
    t.string  "handle"
    t.text    "options"
    t.integer "store_id"
    t.boolean "active",      :default => false
    t.text    "description"
  end

  create_table "imentore_product_brands", :force => true do |t|
    t.string   "name"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "imentore_product_variants", :force => true do |t|
    t.float   "price"
    t.integer "quantity"
    t.string  "sku"
    t.float   "weight"
    t.float   "height"
    t.float   "width"
    t.float   "depth"
    t.boolean "deliverable"
    t.integer "product_id"
  end

  create_table "imentore_products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "permalink"
    t.integer  "store_id"
    t.boolean  "active",           :default => false
    t.integer  "product_brand_id"
    t.string   "handle"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imentore_send_emails", :force => true do |t|
    t.boolean  "active"
    t.string   "name"
    t.string   "subject"
    t.text     "body"
    t.integer  "store_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "imentore_stores", :force => true do |t|
    t.string   "name"
    t.string   "brand"
    t.string   "url"
    t.string   "irs_id"
    t.boolean  "active",                :default => false
    t.text     "settings"
    t.string   "national_id"
    t.string   "date_initial_business"
    t.string   "where_meet_us"
    t.string   "email"
    t.string   "store_type"
    t.integer  "plan_id"
    t.integer  "user_agent_id"
    t.string   "state",                 :default => "pending"
    t.datetime "disabled_at"
    t.datetime "actived_at"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.text     "config"
    t.integer  "old_store_id"
  end

  create_table "imentore_templates", :force => true do |t|
    t.string   "path"
    t.text     "body"
    t.boolean  "partial",                    :default => false
    t.string   "layout"
    t.string   "format",                     :default => "text/html"
    t.string   "locale",                     :default => "en"
    t.string   "handler",                    :default => "liquid"
    t.integer  "theme_id"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.string   "kind"
    t.boolean  "default",                    :default => false
    t.integer  "admin_imentore_template_id"
  end

  create_table "imentore_themes", :force => true do |t|
    t.string  "name"
    t.integer "store_id"
    t.boolean "default",                 :default => false
    t.boolean "active",                  :default => false
    t.boolean "system",                  :default => false
    t.integer "admin_imentore_theme_id"
  end

  create_table "imentore_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "password_salt"
  end

end
