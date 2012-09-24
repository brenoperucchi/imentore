module Old
class User < ActiveRecord::Base

  def self.table_name
    "users"
  end

  self.abstract_class = true
   establish_connection(
   :adapter  => 'mysql2',
   :database => 'go2b_development',
   :host     => 'localhost',
   :username => 'root',
   :password => '',
   :encoding => 'utf8',
   )
   
end
end