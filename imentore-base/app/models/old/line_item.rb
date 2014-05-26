module Old
  class LineItem < ActiveRecord::Base
    belongs_to :payment, class_name: Old::Payment

    belongs_to :variant,
      class_name: Old::ProductVariant
    # belongs_to :order
    #   :class_name => "User",
    #   :foreign_key => :created_by

    has_one :product,
      :through => :variant


    def self.table_name
      "line_items"
    end

    self.abstract_class = true
      establish_connection(
       :adapter  => 'mysql2',
       :database => 'go2b_production',
       :host     => 'localhost',
       :username => 'imentoreapp',
       :password => 'app0p..za'
    )
  end
end