#require 'sentient_store'
require 'imentore'


module Imentore
  class Store < ActiveRecord::Base

    scope :active, -> { where(state: "actived") }

    serialize :config, Settings

    DNS_LABEL_REGEX = /^[a-z][a-z0-9-]*[a-z0-9]$/i
    INVALID_DOMAINS = %w(www mail ftp)

    validates :term, acceptance: true
    validates :url, presence: true, uniqueness: true

    ## TODO verify format in validate presence
    #, format: { with: DNS_LABEL_REGEX }, length: { maximum: 63 }, exclusion: { in: INVALID_DOMAINS } 
    # validates :contract_term, acceptance: true

    belongs_to :old_store, :class_name => 'Old::Store', :foreign_key => "old_store_id"

    has_many :employees, :dependent => :destroy
    has_one  :owner, class_name: Imentore::Employee
    has_one  :address, class_name: Imentore::Address, as: 'addressable', :dependent => :destroy
    has_many :domains, :dependent => :destroy
    has_many :products, :dependent => :destroy
    has_many :orders, :dependent => :destroy
    has_many :invoices, through: :orders
    has_many :payment_methods, :dependent => :destroy
    has_many :delivery_methods, :dependent => :destroy
    has_many :themes, :dependent => :destroy
    has_many :assets, :through => :themes, :source => :assets
    has_many :customers, :dependent => :destroy
    has_many :coupons, :dependent => :destroy
    has_many :coupons_orders, :dependent => :destroy
    has_many :send_emails, :dependent => :destroy
    has_many :categories, :dependent => :destroy
    has_many :product_brands, :dependent => :destroy
    has_many :pages, :dependent => :destroy
    has_many :feedbacks, as: :feedbackable, :dependent => :destroy
    has_many :notices, :dependent => :destroy
    has_many :folders, class_name: Imentore::AssetFolder, :dependent => :destroy
    has_many :users, :dependent => :destroy
    has_many :carts, :dependent => :destroy

    accepts_nested_attributes_for :owner, :address

    def active?
      state == "actived"
    end

    def url_site
      Rails.env.production? ? "#{url}.imentore.com.br" : "#{url}.imentore.dev:4000"
    end

    def theme
      @theme ||= themes.find_by_active(true)
    end

    def email_contact
      config.email_contact.present? ? config.email_contact : email
    end

    def create_defaults
      self.payment_methods.create(name: 'MoIP', handle: 'moip')
      self.payment_methods.create(name: 'PagSeguro', handle: 'pag_seguro')
      self.payment_methods.create(name: 'Pagamento Digital', handle: 'pagamento_digital')
      self.payment_methods.create(name: 'Custom', handle: 'custom', active: true)

      self.delivery_methods.create(name: 'SEDEX', handle: 'sedex', active: true)
      # self.delivery_methods.create(name: 'SEDEX 10', handle: 'sedex_dez', active: true)
      self.delivery_methods.create(name: 'SEDEX a Cobrar', handle: 'sedex_a_cobrar', active: true)
      self.delivery_methods.create(name: 'Pac', handle: 'pac', active: true)
      self.delivery_methods.create(name: 'Weight', handle: 'weight')
      self.delivery_methods.create(name: 'Custom', handle: 'custom')

      category = self.categories.create(name: "Categoria Exemplo", handle:'categoria_exemplo')
      product = self.products.create(name: 'Produto Exemplo', description: "Descricao do Produto", active: true, variants_attributes: [{price: 10, quantity: 10, weight: 1}], category_ids:[category.id])
      default_option = product.options.create(name: I18n.t(:default), handle: I18n.t(:default).to_underscore)
      variant = product.variants.first
      variant.options.create(option_type: default_option, value: I18n.t(:default))

      new_image = product.variants.first.images.new
      new_image.picture = File.open("#{Rails.root}/public/images/product1.jpg")
      new_image.save
      new_image = product.variants.first.images.new
      new_image.picture = File.open("#{Rails.root}/public/images/product2.jpg")
      new_image.save
      
      Imentore::Manager::SendEmail.install_store(self)
      Imentore::Manager::Theme.install_store(self)
    end

    # http://www.ietf.org/rfc/rfc1035.txt
    # [a-z][a-z0-9-]*[a-z0-9]
    # labels are restricted to 63 octets

    #def self.find_by_url(url, active_only = true)
    #with_scope(:find => {:conditions => ["active = ?", active_only]}) do
    #find(:first, :conditions => ["url = ?", url.split('.').first]) || find(:first, :include => :urls, :conditions => ["urls.url = ?", url])
    #end
    #end

    # def full_url
    #   "#{url}.#{APP_DOMAIN}"
    # end
    #
    # def user?(user)
    #   users.include?(user)
    # end
    #
    # def customer?(user)
    #   user.has_role?(:customer, self)
    # end
    #
    # def valid_shipping?(shipping)
    #   shippings.active.not_deleted.include?(shipping)
    # end
    #
    # def create_cashier
    #   ledgers.create(:title => "Caixa", :ro => true)
    # end
    #
    # def create_cost_centers
    #   Imentore.app.cost_centers.each do |cc|
    #     cost_centers.create(:title => cc, :ro => true)
    #   end
    # end
    #
    # def default_values
    #   User.current = users.first
    #   Store.current = self
    #   # pages
    #   pages.create(:name=>I18n.t(:home), :active=>true, :path => "home", :kind=>"fixed" )
    #   pages.create(:name=>I18n.t(:about), :active=>true, :path => "about", :kind =>"custom" )
    #   # pages.create(:name=>"route_policy", :active=>true, :path => "policy" )
    #   # pages.create(:name=>"route_payment", :active=>true, :path => "payment" )
    #   pages.create(:name=>I18n.t(:contact), :active=>true, :path => "contact", :kind=>"fixed" )
    #
    #   # payments
    #   self.payments.create(:name => "Cielo - (Visa/Master/Diners/Elo/Discover)",  :active=> true, :description=> I18n.t(:default_payment_pd_message), :code=>4, :method_type=>"cielo", :qtd_split=>1)
    #   self.payments.create(:name => "Pag Seguro",  :active=> true, :description=> I18n.t(:default_payment_pg_message), :code=>5, :method_type=>"pg", :qtd_split=>1)
    #   self.payments.create(:name => "Pagamento Digital",  :active=> true, :description=> I18n.t(:default_payment_pd_message), :code=>1, :method_type=>"pd", :qtd_split=>1)
    #   self.payments.create(:name => "Deposíto em conta",  :active=> true, :description=> I18n.t(:default_payment_wired_message), :code=>2, :method_type=>"bank", :qtd_split=>1)
    #   # self.payments.create(:name => "Mercado Pago",  :active=> true, :description=> I18n.t(:default_payment_mp_message), :code=>6, :method_type=>"mp", :qtd_split=>1)
    #
    #   payment = self.payments.create(:name => I18n.t(:default_payment_slip),  :active=> true, :description=> I18n.t(:default_payment_wired_message), :code=>3, :method_type=>"slip", :qtd_split=>1)
    #   payment.slips.create(:name=>"Real", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"12345678912",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678912", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #                        :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #   payment.slips.create(:name=>"Itau", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"12345678912",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #                        :number_doc=>"12345678", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #   payment.slips.create(:name=>"Hsbc", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #                        :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #   payment.slips.create(:name=>"Bradesco", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #                        :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #   payment.slips.create(:name=>"BB", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #                        :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #   payment.slips.create(:name=>"Caixa", :code=>"104", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"100000",
    #                        :number_doc=>"123456789123456", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #   payment.slips.create(:name=>"Unibanco", :code=>"409", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #                        :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"100000",
    #                        :number_doc=>"123456789123456", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #                        :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #                        :instruction_6=>I18n.t(:instruction_1), :assignor_address => I18n.t(:assignor_address), :expiration_date => 5 )
    #
    #   # categories
    #   category = categories.create(:title =>"Categoria Exemplo")
    #   # supplier
    #   supplier = suppliers.new(:name=>"Fornecedor Exemplo", :birthdate=>"1987-07-24 00:00:00", :gender=>"M", :email=>"fornecedor@exemplo.com.br", :type=> "Person")
    #   supplier.skip_logger = true
    #   supplier.skip_devise = true
    #   supplier.type = "Person"
    #   supplier.role = "supplier"
    #   supplier.save(false)
    #
    #   product = self.products.new(:name=>"Produto Exemplo", :warranty=>"", :resume=>"", :description=>"Exemplo", :sellable => true, :new=> true, :deal=> true, :featured=>true, :sell_splits => true, :discount_value => 10, :variants_attributes=>[{:name=>I18n.t(:default), :quantity=>10, :value=>10, :value_deal =>5, :value_cost=>1}])
    #   product.categories << category
    #   product.supplier_id = supplier.id
    #   # product.images.build(:picture=> File.open("#{RAILS_ROOT}/public/images/missing_image.png"))
    #   product.images << Image.first
    #   product.save(false)
    #
    #   # theme = StoreTheme.create(:name => "admin_layout_model_1", :active=>true, :store_id=>3)
    #   # variant = theme.variants.create(:name=> "black", :active=>true, :path_name=>"layout_stores_model_1_black", :store_id=>3)
    #   # variant.images.create(:picture=>File.open("#{RAILS_ROOT}/public/images/themes/layout_stores_model_1_black.png"))
    #   # variant = theme.variants.create(:name=> "red", :active=>true, :path_name=>"layout_stores_model_1_red", :store_id=>3)
    #   # variant.images.create(:picture=>File.open("#{RAILS_ROOT}/public/images/themes/layout_stores_model_1_red.png"))
    #   # variant = theme.variants.create(:name=> "orange", :active=>true, :path_name=>"layout_stores_model_1_orange", :store_id=>3)
    #   # variant.images.create(:picture=>File.open("#{RAILS_ROOT}/public/images/themes/layout_stores_model_1_orange.png"))
    #
    # end
    #
    # def create_shippings
    #   s = shippings.build(:name => I18n.t(:default_shipping_custom_weight))
    #   s.code = "WEIGHT"
    #   s.active = true
    #   s.settings = Settings.new
    #   s.save
    #   s = shippings.build(:name => "SEDEX")
    #   s.code = "SEDEX"
    #   s.active = true
    #   s.save
    #   s = shippings.build(:name => "PAC")
    #   s.code = "PAC"
    #   s.active = true
    #   s.save
    # end
    #
    # def create_store_emails
    #   StoreEmail.find_all_by_store_id(1).each do |email|
    #     self.store_emails.create(email.attributes)
    #   end
    # end
    #
    # def delete_store
    #   self.address.nil? ? true : self.address.destroy
    #   self.images.destroy
    #   self.store_emails.destroy
    #   self.sas.destroy
    #   self.statistics.destroy
    #   self.surveys.destroy
    #   self.carts.destroy
    #   self.logs.destroy
    #   self.urls.destroy
    #   self.business_plans.destroy
    #   self.shippings.destroy
    #   self.products.destroy
    #   self.categories.destroy
    #   self.ledger_items.destroy
    #   self.cost_centers.destroy
    #   self.ledgers.destroy
    #   self.rmas.destroy
    #   self.orders.destroy
    #   self.users.destroy
    #   self.payments.destroy
    #   self.pages.destroy
    #   self.notices.destroy
    #   self.lists.destroy
    #   self.adverts.destroy
    #   self.store_invoices.destroy
    #
    #   a = self
    #   a.destroy
    #   puts a.inspect
    #   puts a.errors.full_messages
    # end
    #
    # def deliver_confirm
    #   StoreMailer.deliver_confirm(self, self.users.first)
    # end
    #
    # def email_contact
    #   if self.settings.email_contact.blank?
    #     self.settings['email_contact'] = self.users.first.email
    #     self.email ||= self.users.first.email
    #     save
    #     self.settings.email_contact
    #   else
    #     self.settings.email_contact
    #   end
    # end
    #
    # def domain?
    #   current_store ||= self
    #   return current_store.urls.count > 0 ? current_store.urls.first.url : "imentore.com.br"
    # end
    #
    # def site?
    #   current_store ||= self
    #   if current_store.urls.count > 0
    #     site = "http://www.#{current_store.urls.first.url}/"
    #   else
    #     site = "http://#{current_store.url}.imentore.com.br/"
    #   end
    #   return site
    # end
    #
    # def theme?
    #   settings.theme + "_" + settings.theme_variant
    # end

    # def change
    #   Store.all.each do |store|
    #     s = store.shippings.build(:name => I18n.t(:default_shipping_custom_weight))
    #     s.code = "WEIGHT"
    #     s.active = true
    #     s.settings = Settings.new
    #     s.save
    #   end
    # end

    # def change
    # Store.all.each do |store|
    # store.payments.create(:name => "Cielo - (Visa/Master/Diners/Elo/Discover)",  :active=> true, :description=> I18n.t(:default_payment_pd_message), :code=>4, :method_type=>"cielo", :qtd_split=>1)
    # end
    # end

    # def self.campanha(name,store,user)
    #   store = Store.first
    #   user = user
    #   StoreMailer.deliver_campanha(user, store, name)
    # end
    # def campanha(name)
    # Store.all.each do |store|
    # begin
    # puts store.id
    # if store.user_agent.present?
    # else
    # if not store == Store.first or store == Store.find(41)
    # store.users.each do |user|
    # begin
    # StoreMailer.deliver_campanha(user, store, name)
    # rescue
    # true
    # end
    # puts user.name
    # puts user.id
    # end
    # end
    # end
    # rescue
    # true
    # end
    # end
    # end


    # def self.campanha_21_2011_01
    #   for i in 1..220 do
    #     begin
    #       store = Store.find(i)
    #       puts store.id
    #       if store.user_agent.present? and store.user_agent.owner != store
    #         store.users.each do |user|
    #           if not (store.users.first == user or user.role == "admin" and user.role == "employee")
    #             begin
    #               StoreMailer.deliver_campanha_21_2011_01(user)
    #             rescue
    #               true
    #             end
    #             puts user.name
    #             puts user.id
    #           end
    #         end
    #       else
    #         if not store == Store.first or store == Store.find(41)
    #           store.users.each do |user|
    #           begin
    #             StoreMailer.deliver_campanha_21_2011_01(user)
    #           rescue
    #             true
    #           end
    #           puts user.name
    #           puts user.id
    #         end
    #       end
    #     end
    #     rescue
    #       true
    #     end
    #   end
    # end

    # def self.send_emails
    #   Store.all.each do |s|
    #       StoreMailer.deliver_campaign_14062011(s, s.users.first)
    #   end
    # end
    #
    # def envio
    #   Store.all.each do |store|
    #     if store.user_agent.present? and store.user_agent.owner != store
    #       return false
    #     else
    #       StoreMailer.deliver_news_imentore_102011_01(store.users.first)
    #     end
    #   end
    #
    # end
    #
    #
    # def self.news_imentore_102011_01
    #   @users = Store.first.users
    #   @users.each do |user|
    #     StoreMailer.deliver_news_imentore_102011_01(user)
    #   end
    # end
    # def self.send_emails
    #   for i in 37..100 do
    #     begin
    #       Store.find(i)
    #       StoreMailer.deliver_store_notice_062011_01(s.find(i), s.users.first)
    #     rescue
    #       "not find"
    #     end
    #   end
    #
    # end


    # def self.send_emails_users
    #   Store.find(3).users.all.each do |u|
    #     StoreMailer.deliver_campaign_14062011(Store.find(3), u)
    #   end
    # end

    # def change
    #     Page.find(:all, :conditions=>{:path =>"payments"}).each do |page|
    #       page.update_attribute(:path, "payment")
    #     end
    #   end


    # def change
    #   Store.all.each do |store|
    #     store.pages.find_by_url("route_payments").update_attribute(:path, "payment") if store.pages.find_by_url("route_payments").present?
    #   end
    # end

    # def change
    #   PaymentSlip.all.each do |slip|
    #     slip.destroy if slip.name == "Santander"
    #   end
    # end
    #
    #     def change
    #       Store.all.each do |s|
    #   # s = Store.first
    #       # s.payments.find_by_method_type("slip").destroy
    #       # payment = s.payments.create(:name => I18n.t(:default_payment_slip),  :active=> true, :description=> I18n.t(:default_payment_wired_message), :code=>3, :method_type=>"slip", :qtd_split=>1)
    #   payment = s.payments.find_by_method_type("slip")
    #       payment.slips.create(:name=>"Real", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"12345678912",
    #       :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678912", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #       :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #       :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #       :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #       payment.slips.create(:name=>"Itau", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"12345678912",
    #       :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #       :number_doc=>"12345678", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #       :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #       :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #       payment.slips.create(:name=>"Hsbc", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #       :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #       :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #       :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #       :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #       payment.slips.create(:name=>"Bradesco", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #       :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #       :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #       :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #       :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #
    #       payment.slips.create(:name=>"BB", :active=>true, :assignor=>I18n.t(:assignor), :assignor_doc=>"123456789123456",
    #       :drawee=>I18n.t(:drawee), :drawee_doc=>"12345678900", :accept=>"S", :agency=>"1565", :checking_account=>"61900", :covenant=>"12387989",
    #       :number_doc=>"777700168", :instruction_1=>I18n.t(:instruction_1), :instruction_2=>I18n.t(:instruction_1),
    #       :instruction_3=>I18n.t(:instruction_1), :instruction_4=>I18n.t(:instruction_1), :instruction_5=>I18n.t(:instruction_1),
    #       :instruction_6=>I18n.t(:instruction_1), :assignor_address=>I18n.t(:assignor_address), :expiration_date => 5)
    #       end
    #     end
    # def change
    # StoreInvoice.all.each do |invoice|
    # invoice.invoiceable_id = invoice.store_id
    # invoice.invoiceable_type = 'Store'
    # invoice.save
    # end
    # end
  end
end
