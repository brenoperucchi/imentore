module Old
  class Page < ActiveRecord::Base

    def self.table_name
      "pages"
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