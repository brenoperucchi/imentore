module Old
  class Category < ActiveRecord::Base
    has_ancestry 

    def self.table_name
      "categories"
    end

    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'imentore_go2b',
     :host     => 'host.imentore.com.br',
     :username => 'go2b',
     :password => '123123'
     )   
  end
end