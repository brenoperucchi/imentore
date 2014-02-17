module Old
  class CategoriesProduct < ActiveRecord::Base  

    def self.table_name
      "categories_products"
    end

    self.abstract_class = true
      establish_connection(
       :adapter  => 'mysql2',
       :database => 'go2b_production',
       :host     => 'host.imentore.com.br',
       :username => 'imentoreapp',
       :password => 'app0p..za'
    )

    # after_save :set_supplier
    before_save :set_supplier_before
    # before_update :set_supplier_before
    
    belongs_to :product, :class_name => "Product", :foreign_key => "product_id"
    belongs_to :category, :class_name => "Category", :foreign_key => "category_id"
    belongs_to :supplier, :class_name => "User", :foreign_key => "supplier_id", :conditions => {:role=>"supplier"} 

    def set_supplier_before
      # Rails.logger.debug { "after=> #{self.inspect }"}
      # Rails.logger.debug { "after=> #{self.product.supplier}"}
      self.supplier = product.supplier 
      self.supplier_id = product.supplier_id
    end
  end
end
