module Imentore

  class AddressStruct

    # attr_accessor :name, :street, :complement, :city, :state, :country, :zip_code, :phone

    def [](key, *args)
          var_name = "@#{key}"
          self.instance_variable_set(var_name, args)
          binding.pry
        # end
      # base.register_attributes *attributes
      # base.class_eval do
        # validates :theme, presence: true
      # end
    end

    def method_missing(key, *args)
      # self.try(key.to_sym, key.to_s)
      # self.try(:[], self, key)
      self.try(:[], key, args)
      # send(key)
          # binding.pry
      # self.respond_to?(key) ? self.try(:[], key, args) : self.try(:[]=, key, args)

      # included(self, key, args)
    end

  end

  class Order < ActiveRecord::Base
    attr_accessor :payment_method, :delivery_method, :billing_checkbox, :shipping_checkbox
    serialize :items, Array
    serialize :billing_address, Imentore::Address

    validates :payment_method, presence: true
    validates :delivery_method, presence: true

    belongs_to  :store
    has_one     :invoice,   dependent: :destroy
    has_one     :delivery,  dependent: :destroy

    # validates :payment_method, presence: true

    def total_amount
      items.sum(&:price)
    end

    def chargeable?
      total_amount > 0
    end

    def deliverable?
      items.map(&:deliverable?).inject(true, :&)
    end
  end
end
