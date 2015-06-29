# encoding: utf-8
module Old
  class ProductVariant < ActiveRecord::Base

  def self.table_name
  #   "product_variants"
    "imentore_product_variants"
  end
  self.abstract_class = true
   establish_connection(
   :adapter  => 'mysql2',
   :database => 'imentore2',
   :host     => 'dns.imentore.com.br',
   :username => 'imentore2',
   :password => '123123'
   )
  
  ## TODO
  # has_many :images,
  #   :class_name => Old::Image,
  #   :as => :imageable,
  #   :dependent => :destroy,
  #   :finder_sql => proc {" SELECT imentore_images.* FROM imentore_images  WHERE imentore_images.imageable_id = #{self.id} AND imentore_images.imageable_type = 'Imentore::ProductVariant' "}  
      
  belongs_to :product

  has_many :units,
    :class_name => Old::InventoryUnit,
    :foreign_key => :variant_id,
    :dependent => :destroy

  scope :not_deleted, -> { where(deleted_at: nil) }

  end
end