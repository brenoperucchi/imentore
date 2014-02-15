module Old
  class ProductVariant < ActiveRecord::Base

  def self.table_name
    "product_variants"
  end
  
  self.abstract_class = true
   establish_connection(
   :adapter  => 'mysql2',
   :database => 'go2b_production',
   :host     => 'localhost',
   :username => 'go2b',
   :password => '123123'
   )
      
  belongs_to :product

  has_many :units,
    :class_name => Old::InventoryUnit,
    :foreign_key => :variant_id,
    :dependent => :destroy


  scope :not_deleted, where(deleted_at: nil)


  end
end