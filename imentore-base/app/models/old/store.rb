module Old
  class Store < ActiveRecord::Base

    def self.table_name
      # "stores"
      "imentore_stores"
    end
    
    has_many :categories, :dependent => :destroy

    has_many :users, :dependent => :destroy

    has_many :pages

    has_many :notices

    has_many :products,
      :class_name => Old::Product,
      :dependent => :destroy

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

    has_many :orders,
      :class_name => Old::Order
      # :conditions => "role = 'dealer'"

    scope :active, where(state: 'actived')

    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'imentore2',
     :host     => 'dns.imentore.com.br',
     :username => 'imentore2',
     :password => '123123'
     )

    # self.abstract_class = true
    #  establish_connection(
    #  :adapter  => 'mysql2',
    #  :database => 'go2b_production',
    #  :host     => 'app.imentore.com.br',
    #  :username => 'imentoreapp',
    #  :password => 'app0p..za'
    #  )

     def active?
       state == "actived"
     end

  end
end