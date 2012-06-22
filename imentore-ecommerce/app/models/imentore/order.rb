module Imentore
  require_dependency "imentore/line_item"
  require_dependency "imentore/product"
  require_dependency "imentore/product_variant"
  require_dependency "imentore/coupon"

  # class AddressStruct

  #   # attr_accessor :name, :street, :complement, :city, :state, :country, :zip_code, :phone

  #   def [](key, *args)
  #         var_name = "@#{key}"
  #         self.instance_variable_set(var_name, args)
  #         binding.pry
  #       # end
  #     # base.register_attributes *attributes
  #     # base.class_eval do
  #       # validates :theme, presence: true
  #     # end
  #   end

  #   def method_missing(key, *args)
  #     # self.try(key.to_sym, key.to_s)
  #     # self.try(:[], self, key)
  #     self.try(:[], key, args)
  #     # send(key)
  #         # binding.pry
  #     # self.respond_to?(key) ? self.try(:[], key, args) : self.try(:[]=, key, args)

  #     # included(self, key, args)
  #   end

  # end

  class Order < ActiveRecord::Base
    attr_accessor :billing_checkbox, :shipping_checkbox

    mattr_accessor :sent_email
    self.sent_email = false

    serialize :items, Array

    serialize :billing_address, Imentore::Address
    serialize :shipping_address, Imentore::Address

    belongs_to  :store
    belongs_to  :user
    has_many    :assets,    class_name: "OrderAsset", as: 'assetable'
    has_one     :invoice,   dependent: :destroy, validate: true
    has_one     :delivery,  dependent: :destroy, validate: true

    has_many :coupons_orders
    has_many :coupons, :through => :coupons_orders, :source => :coupon
    validate :valid_addresses, :on => :update

    validates :customer_name, :customer_email, presence: true, :on => :update

    def valid_addresses
      errors.add(:base, "err") unless (billing_address.valid? && shipping_address.valid?)
    end

    def update_status
      self.finish if invoice.confirmed? and delivery.sent?
    end

    state_machine :status, :initial => :pending do
      event :place do
        transition :pending => :placed
      end
      event :finish do
        transition :placed => :finished
      end
    end


    def products_amount
      items.sum(&:amount).to_f
    end

    def delivery_amount
      delivery_method.nil? ? 0 : delivery_calculate(zip_code, delivery_method).value
    end

    def coupons_amount
      coupons.sum(&:value)
    end

    def delivery_calculate(zip_code, method)
      Imentore::DeliveryHandle.calculate_items(self.items, zip_code, delivery.delivery_method)
    end

    def invoice_method
      invoice.try(:payment_method)
    end

    def delivery_method
      delivery.try(:delivery_method)
    end

    def zip_code
      shipping_address.zip_code || nil
    end

    def total_amount
      delivery_amount + items.sum(&:amount) + coupons_amount
    end

    def chargeable?
       total_amount > 0
    end

    def deliverable?
      items.map(&:deliverable?).inject(true, :&)
    end


  end
end
