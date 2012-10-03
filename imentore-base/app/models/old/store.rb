module Old
  class Store < ActiveRecord::Base

    def self.table_name
      "stores"
    end
    
    has_many :categories, :dependent => :destroy

    has_many :users, :dependent => :destroy

    has_many :pages

    has_many :notices

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
     :database => 'imentore_go2b',
     :host     => 'host.imentore.com.br',
     :username => 'go2b',
     :password => '123123'
     )

  end
end