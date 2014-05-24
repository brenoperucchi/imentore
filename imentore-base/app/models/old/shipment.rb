module Old
  class Shipment < ActiveRecord::Base
    # self.inheritance_column = :foo
    # attr_accessible :type
    belongs_to :shipping, class_name: Old::Shipping

    def self.table_name
      "shipments"
    end

    def address
      @address ||= Old::Address.new.from_json(self.read_attribute(:address)) rescue nil
    end


    self.abstract_class = true
      establish_connection(
       :adapter  => 'mysql2',
       :database => 'go2b_production',
       :host     => 'app.imentore.com.br',
       :username => 'imentoreapp',
       :password => 'app0p..za'
    )
  end
end