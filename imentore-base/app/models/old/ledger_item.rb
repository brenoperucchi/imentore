module Old
  class LedgerItem < ActiveRecord::Base
    self.inheritance_column = :foo
    attr_accessible :type
    belongs_to :payment, class_name: Old::Payment

    def self.table_name
      "ledger_items"
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