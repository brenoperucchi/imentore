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
    acts_as_paranoid
    
    attr_accessor :shipping_checkbox, :payment_url, :valid_billing, :validate_step

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

    accepts_nested_attributes_for :invoice, :delivery

    validate :validate_checkout, unless: "validate_step.nil?"

    ## TODO change this to state_machine behavor 
    def validate_checkout
      case validate_step
      when :initial
        validates_presence_of :customer_name, :customer_email
        errors.add(:base, "error") unless shipping_address.valid?
      when :second
        errors.add(:base, "error") unless delivery.try(:valid?)
      when :third
        errors.add(:base, "error") unless invoice.try(:valid?)# and !self.can_place? and !self.canceled?
      else
        true
      end
    end

    def update_status
      self.finish if invoice.confirmed? and delivery.sent?
    end

    def valid_stock?(event = nil)
      self.items.each do |i| 
        unless i.variant.valid_stock?(i.quantity)
          self.errors.add(:base, I18n.t(:stock_null, scope: [:activerecord, :attributes, :errors, self.class.name.to_underscore]))
          return false
        end
      end
    end

    state_machine :status, :initial => :pending do
      # after_transition :on => [:paid, :canceled], :do => :update_balance
      before_transition :pending => :placed,                do: :valid_stock?
      after_transition [:placed, :finished] => :canceled,   do: :update_stock
      after_transition :pending => :placed,                 do: :update_stock
      after_transition :pending => :placed,                 do: :after_placed

      event :place do
        transition :pending => :placed
      end
      event :finish do
        transition :placed => :finished
      end
      event :cancel do
        transition [:pending, :placed, :finished] => :canceled
      end

      # state :pending, :canceled do
      #   valid_stock?
      # end
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

    def after_placed
      if self.placed? and not self.sent_email
        store = self.store
        send_email = store.send_emails.find_by_name('order_placed').prepare(self)
        Imentore::SendEmailMailer.send_mail_mailer(store.email_contact,self.customer_email, send_email.topic, send_email.frame).deliver if send_email.active?
        self.sent_email = true
      end
    end

    def products_amount
      items.to_a.sum(&:amount).to_f
    end

    def delivery_amount
      delivery.try(:amount) ? delivery.try(:amount) : 0
    end

    def payment_amount
      invoice_method ? (invoice_method.options['overcharge'] ? invoice_method.options['overcharge'].to_f : 0) : 0
    end

    def coupons_amount
      coupons.sum(:value)
    end

    def delivery_calculate(zip_code, method)
      return false if zip_code.nil? or method.nil?
      handle = Imentore::DeliveryHandle.new(self.items, zip_code, store.config.store_zip_code, method)
      handle.calculate
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
      delivery_amount + items.sum(&:amount) + coupons_amount + payment_amount
    end

    def chargeable?
       total_amount > 0
    end

    def deliverable?
      valid_stock? ? true : false
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
        
  end
end
