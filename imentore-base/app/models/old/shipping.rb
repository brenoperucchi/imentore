module Old
  class Shipping < ActiveRecord::Base
    # self.inheritance_column = :foo
    # attr_accessible :type
    # belongs_to :shipping, class_name: Old::Shipping

    def self.table_name
      "shippings"
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