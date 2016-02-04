class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :imentore_stores do |t|
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
      t.timestamps
    end
  end

  def self.down
    drop_table :imentore_stores
  end
end
