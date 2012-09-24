module Old
class Store < ActiveRecord::Base

  def self.table_name
    "stores"
  end

  has_many :pages

  has_many :products, :dependent => :destroy

  has_many :customers,
    :conditions => "role = 'customer'",
    :class_name => Old::User

  has_many :employees,
    :class_name => Old::User,
    :conditions => "role = 'employee'"

  has_many :suppliers,
    :class_name => Old::User,
    :conditions => "role = 'supplier'"

  has_many :dealers,
    :class_name => Old::User,
    :conditions => "role = 'dealer'"

  scope :active, where(state: 'actived')

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