module Old
  class Order < ActiveRecord::Base

    def self.table_name
      "orders"
    end

    self.abstract_class = true
      establish_connection(
       :adapter  => 'mysql2',
       :database => 'go2b_production',
       :host     => 'localhost',
       :username => 'imentoreapp',
       :password => 'app0p..za'
    )


    # after_create :logger, :notice_store_email_contact

    # has_many :customers_coupons
    # has_many :customers, :through => :customers_coupons, :source => :user
    # has_many :coupons, :through => :customers_coupons, :source => :coupon

    # has_many :store_files,
    #   :as => :fileable,
    #   :class_name=> 'StoreFile',
    #   :dependent => :destroy

    has_many :items,
      :class_name => Old::LineItem,
      :dependent => :destroy

    #has_many :items_units,
      #:through => :items,
      #:source => :units,
      #:validate => false

    # has_many :coupons

    # has_many :emails,
    #   :as => :emailable,
    #   :dependent => :destroy

    has_many :shipments,
      :class_name => Old::Shipment,
      :dependent => :destroy

    has_many :invoices,
      :class_name => Old::LedgerItem,
      :validate => false,
      :conditions => "type = 'Invoice'"

    # has_many :logs,
    #   :as => :loggable,
    #   :validate => false

    # has_many :refunds,
    #   :validate => false

    # has_many :rmas,
    #   :dependent => :destroy,
    #   :validate => false

    # has_many :uploads, :finder_sql => 'SELECT `uploads`.* FROM `uploads` INNER JOIN (`line_items`, `product_variants`) ON `product_variants`.id = `line_items`.variant_id WHERE ((`line_items`.order_id = #{self.id})) GROUP BY `uploads`.id'
    # has_many :files_orders
    # has_many :files, :through => :files_orders, :source => :file, :uniq => true
    # has_many :uploads, :through => :files_orders, :source => :file, :uniq => true, :conditions=>"type = 'FileUpload'"
    # has_many :downloads, :through => :files_orders, :source => :file, :uniq => true, :conditions=>"type = 'FileDownload'"

    # has_many :categories, :through => :categories_products, :source => :category

    belongs_to :user, :class_name => Old::User
    belongs_to :store, :class_name => Old::Store
    # belongs_to :address, :class_name => Old::Address

    # belongs_to :survey,
    #   :class_name => "Survey"

    # validates_presence_of :store_id, :user_id #, :address_id
    #validates_associated :address, :store, :user
    #validates_length_of :item_ids, :minimum => 1
    #validate :presence_of_items
    # accepts_nested_attributes_for :items, :shipments

    # named_scope :static_gender_month, lambda {|gender,month_start,month_end| {:joins=>:user, :conditions => ["gender = ? AND users.type = 'Person' AND orders.updated_at BETWEEN ? AND ?", gender, month_start, month_end] } }
    # named_scope :static_order_month, lambda { |month_start,month_end| {:joins=>:user, :conditions => ["users.type = 'Person' AND orders.updated_at BETWEEN ? AND ?", month_start, month_end] } }
    # named_scope :static_gender_company_month, lambda { |month_start,month_end| {:joins=>:user, :conditions => ["users.type = 'Company' AND orders.updated_at BETWEEN ? AND ?", month_start, month_end] } }
    # Soft delete.
    scope :not_deleted, where('orders.deleted_at IS NULL')
    scope :deleted, where('orders.deleted_at IS NOT NULL')

    # named_scope :uploads, :joins => [:variant, :upload], :conditions => ["product_variants.id = line_items.variant_id and product_variants.product_id = uploadable_id and upload_type = 'Product'"]

    # Search
    # named_scope :search,
    #   lambda {|id, date, customer, price| {
    #     :joins => :user, :conditions => ["(? = '' OR orders.id = ?) AND (? = '' OR DATE_FORMAT(DATE_ADD(orders.created_at, INTERVAL ? HOUR), '%d/%m/%Y') = ?) AND (? = '%%' OR users.name LIKE ?) AND (? = '' OR orders.price = ?)", id,id,date,Time.now.strftime("%z").delete("0"),date,"%#{customer}%","%#{customer}%",price,price]
    #   } }

    def notice_store_email_contact
      # body = ""
      # body << "# Pedido: #{self.id}\n"
      # body << "Data Pedido: #{I18n.l(DateTime.now, :format=>:long)}\n"
      # body << "Cliente: #{self.user.name}\n"
      # body << "Cliente Email: #{self.user.email}\n"
      # PublicMailer.deliver_email_sender(self.store.email_contact, self.store.email_contact, "Aviso de Criação Pedido na Loja", body)
    end

    def calculate_coupons
      value = 0
      coupons.each { |c| value += c.value }
      value
    end


    def logger(action='created')
      Log.logger(self, "#{I18n.t(:order)} ##{id} #{I18n.t(action).downcase}")
    end

    # Soft delete
    def destroy
      self.update_attribute(:deleted_at, DateTime.now);
      logger('destroyed')
      return true
    end

    state_machine :initial => :shipment do
      after_transition :on => :replace, :do => lambda { |order| Log.logger(order, I18n.t(:order_replaced, :order_id=>order.id)) }
      after_transition :on => :cancel, :do => lambda { |order| Log.logger(order, I18n.t(:order_canceled, :order_id=>order.id)) }
      after_transition :on => :close, :do => lambda { |order| Log.logger(order, I18n.t(:order_closed, :order_id=>order.id)) }
      after_transition :on => :place, :do => :reserve_units

      event :checkout do
        transition :shipment => :checkout
      end

      event :place do
        transition :checkout => :placed
      end

      event :close do
        transition [:shipment, :placed, :checkout] => :closed
      end

      event :replace do
        transition any => :placed
      end

      event :cancel do
        transition any => :canceled
      end
    end

    state_machine :payment_state, :initial => :pending, :namespace => 'payment' do
      # after_transition :on => :confirm, :do => lambda { |order| Log.logger(order, "#{order.id} - #{I18n.t(:confirm_payment)} #{self.id}") }
      # after_transition :on => :confirm, :do => :store_email
      after_transition :do => :updated_state_order
      event :authorize do
        transition :pending => :authorized
      end

      event :confirm do
        transition any => :paid
      end

      event :pend do
        transition any => :pending
      end

      event :cancel do
        transition any => :canceled
      end
    end

    # def store_email
    #   StoreEmailMailer.deliver_confirm_order_paid(self.store, self)
    # end

    state_machine :shipping_state, :initial => :not_shipped, :namespace => 'shipping' do
      # after_transition :on => :done, :do => lambda { |order| Log.logger(order, I18n.t(:done_shipping)) }
      after_transition :do => :updated_state_order
      event :pending do
        transition any => :not_shipped
      end

      event :partial do
        transition any => :partial
      end

      event :done do
        transition any => :shipped
      end
    end

    state_machine :upload_state, :initial => :pending, :namespace => 'upload' do
      event :authorize do
        transition :pending => :authorized
      end

      event :send do
        transition any => :sent
      end

      event :cancel do
        transition any => :canceled
      end
    end


    def updated_state_order
      if shipping_state == 'shipped' and payment_state == 'paid'
        close!
      elsif closed?
        replace!
      end
    end

    def presence_of_items
      errors.add(:items, :too_short) if items.size == 0
    end


    def build_line_items_from_cart(cart)
      cart.items.each do |item|
        line_item = items.build({
          :quantity => item.quantity,
          :message => item.message,
          :variant_id => item.variant_id
        })
        item.downloads.each do |file|
          line_item.files_orders.build({
            :order => self,
            :store => self.store,
            :file => file,
            :product => item.variant.product
          })
        end
      end
    end

    def build_coupons_from_cart(cart)
      cart.customers_coupons.each do |c|

        c.update_attribute(:order_id, self.id)
      end
    end

    def price
      price = 0
      items.each { |i| price += i.price }
      price
    end

    def shipments_price
      shipments.sum(:price)
    end

    def refunds_amount
      refunds.sum(:amount)
    end

    def invoices_amount
      invoices.not_canceled.sum(:total_amount)
    end

    def coupon_amount
      coupons.all.sum(&:value)
    end

    #def shipments_price
      #price = 0
      #shipments.each { |s| price += s.price }
      #price
    #end

    def total_price
      price + shipments_price
    end

    #def total_weight
      #weight = 0
      #items.each { |i| weight += i.weight }
      #weight
    #end


    def build_shipment_for_items(shipping_id, ids = nil)
      ids ||= items.without_shipment.collect { |s| s.id }
      shipment = shipments.build(:shipping_id => shipping_id, :item_ids => ids)
      #items.each do |i|
        #i.shipment = shipment if ids.include?(i.id) # where's the cache!?
      #end
      #items.find(ids).each do |i|
        #i.shipment = shipment
      #end
    end


    def build_shipments(shippings, ids)
      #ids = items.without_shipment.collect { |s| s.id.to_s } if ids.empty?
      #errors.add_to_base(:empty) and return false if ids.empty?
      if shippings.has_key?('0')
        #build_shipment_for_items(shippings['0']['id'], items)
        self.shipments.build(:shipping_id => shippings['0'], :item_ids => ids)
      else
        shipments = {}
        ids.each { |i| shipments[shippings[i.to_s]] ? shipments[shippings[i.to_s]] << i : shipments[shippings[i.to_s]] = [i.to_i] }
        #shippings.delete_if { |k,v| !ids.include?(k) }
        #shippings.each { |item, shipping| shipments[shipping] ? shipments[shipping] << item.to_i : shipments[shipping] = [item.to_i] }
        #shipments.each { |shipping, item| build_shipment_for_items(shipping, item) }
        shipments.each { |shipping, item| self.shipments.build(:shipping_id => shipping, :item_ids => item) }
      end
    end


    def reserve_units
      items.each do |item|
        item.reserve_units
      end
    end


    def rmas_unit_ids
      rmas.collect { |rma| rma.unit_ids }.flatten.uniq
    end


    def shipped_items
      shipments.shipped.collect { |s| s.items }.flatten.uniq
    end

    def copy_values
      self.price = items.sum(:price)
      self.weight = items.sum(:weight)
      self.save(false)
    end

    # def update_payment_state(state)
    #   # if invoices.count > 0
    #   #   if invoices.pending.count > 0 || invoices.canceled.count > 0
    #   #     pend_payment
    #   #   else
    #   #     confirm_payment
    #   #   end
    #   # end
    # end

    #def create_invoice
      #invoices.create(:total_amount => total_price, :title => "Pedido ##{id}")
    #end

    def update_attributes(*params)
      # return false unless params.nil?
      this, attribute, param = params
      this.each do |is|
        is.update_attribute(attribute, param)
      end
    end

    def create_checkout_invoice
      # @invoice = Invoice.new(:total_amount => total_price, :title => I18n.t(:order_log_msg, :id=>id), :ledger => store.cashier, :issued_at => Time.now, :store_id =>self.store_id, :order=>self)
      @invoice = self.invoices.create(:total_amount => total_price, :title => I18n.t(:order_log_msg, :id=>id), :ledger => store.cashier, :issued_at => Time.now, :store_id =>self.store_id)
      update_attributes(items, :ledger_item_id, @invoice.id)
      update_attributes(shipments, :ledger_item_id, @invoice.id)
      @invoice
    end

  end
end