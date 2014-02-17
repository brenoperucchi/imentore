module Old
  class Category < ActiveRecord::Base
    has_ancestry 

    def self.table_name
      "categories"
    end

    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'go2b_production',
     :host     => 'host.imentore.com.br',
     :username => 'go2b',
     :password => 'app0p..za'
     )   
  end
end