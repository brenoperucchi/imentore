module Old
  class Payment < ActiveRecord::Base
    # belongs_to :payment, class_name: Old::ProductVariant

    def self.table_name
      "payments"
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