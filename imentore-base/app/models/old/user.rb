module Old
  class User < ActiveRecord::Base

    def self.table_name
      "users"
    end

    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'go2b_production',
     :host     => 'localhost',
     :username => 'go2b',
     :password => '123123'
     )   
  end
end