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
    validate :valid_addresses, :on => :update, unless: Proc.new {|order| order.canceled?}
    validates :customer_name, :customer_email, presence: true, :on => :update, unless: Proc.new {|order| order.canceled?}

    def valid_addresses
      valid_billing = billing_address.valid? 
      valid_address = shipping_address.valid? 
      errors.add(:base, "err") unless valid_address && valid_billing
      valid_billing && valid_address
    end

    def update_status
      self.finish if invoice.confirmed? and delivery.sent?
    end

    # def update_stock(event)
      # binding.pry
      # items.each do |item|
        # item.variant.update_stock.      
    # end

    state_machine :status, :initial => :pending do
      # after_transition :on => [:paid, :canceled], :do => :update_balance
      after_transition [:placed, :finished] => :canceled,   do: :update_stock
      after_transition :pending => :placed,                 do: :update_stock
      before_transition :pending => :placed,                do: :valid_stock?

      event :place do
        transition :pending => :placed
      end
      event :finish do
        transition :placed => :finished
      end
      event :cancel do
        transition [:pending, :placed, :finished] => :canceled
      end

      state :pending, :canceled do
        def valid_stock?(event)
          unless self.items.detect {|i| i.variant.valid_stock?(i.quantity)}
            errors.add(:base, I18n.t(:stock_null, scope: [:activerecord, :attributes, :errors, self.class.name.to_underscore]))
            return false
          end
        end
      end
      state :placed, :canceled do
        def update_stock(event)
          case event.to
          when "placed"
            self.items.each {|i| i.variant.update_stock(- i.quantity)}
          when "canceled"
            self.items.each {|i| i.variant.update_stock(i.quantity)}
          end
        end
      end
    end


    def products_amount
      items.sum(&:amount).to_f
    end

    def delivery_amount
      delivery.try(:amount) ? delivery.try(:amount) : 0
    end

    def coupons_amount
      coupons.sum(&:value)
    end

    def delivery_calculate(zip_code, method)
      return false if zip_code.nil? or method.nil?
      Imentore::DeliveryHandle.calculate_items(self.items, zip_code, method).value
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
      # validation = items.each{|i| break if i.variant.quantity > 0}.nil?
      # self.errors.add(:base, :not_delivery) if validation
      # validation
      if items.each{|i| break if i.variant.quantity > 0}.nil?
        true
      else
        self.errors.add(:base, :not_delivery)
        false
      end
    end

    def shipment_calculate
      delivery = delivery_calculate(zip_code, delivery_method)
      unless items.map(&:deliverable?).inject(true, :&)
        self.errors.add(:base, :not_delivery)
        return false
      end
      unless delivery.error == "0"
        self.errors.add(:base, delivery.error_msg)
        return false
      end
      true      
    end

    # def self.search(id, condition, created_at, email)
    #   condition = self
    #   condition = where('id LIKE ?', (id + '%')) unless id.nil? or id.blank?
    #   condition
    # end
    
  end
end
