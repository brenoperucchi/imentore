module Imentore
  class User < ActiveRecord::Base

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :authentication_keys => [:email, :store_id]

    validates_uniqueness_of    :email,     :case_sensitive => false, :allow_blank => true, scope: [:email, :store_id], :if => :email_changed?
    validates_format_of :email, :with  => Devise.email_regexp, :allow_blank => true, :if => :email_changed?
    validates_presence_of   :password, :on=>:create
    validates_confirmation_of   :password, :on=>:create
    validates_length_of :password, :within => Devise.password_length, :allow_blank => true

    belongs_to :store
    belongs_to :userable, polymorphic: true

    def self.find_first_by_auth_conditions(warden_conditions)   
      conditions = warden_conditions.dup
      store_id = conditions.delete(:store_id)
        # where(conditions).where(["lower(store_id) = :value OR lower(store_id) = :value", { :value => store_id.downcase }]).first
        # where(conditions).joins('JOIN imentore_employees ON imentore_users.userable_id = imentore_employees.id').first
        # where(conditions).joins('JOIN imentore_customers ON imentore_users.userable_id = imentore_customers.id').where('imentore_customers.store_id = :value', {:value => store_id }).first
        where(conditions).where('imentore_users.store_id = :value', {:value => store_id }).first
      # else
        # where(conditions).first
      # end
    end

    # def self.find_for_database_authentication(warden_conditions)
    #   conditions = warden_conditions.dup
    #   store_id = conditions.delete(:store_id)
    #   where(conditions).where(["imentore_users.store_id = :value", { :value => store_id.strip.downcase }]).first
    # end

    # def self.find_for_database_authentication(warden_conditions)
    #   # conditions = warden_conditions.dup
    #   # login = conditions.delete(:login)
    #   # account_id = conditions.delete(:account_id)
    #   # where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).where("account_id = ?", account_id).first
    # end 


    # Imentore::User.find(:all, :limit => 10, 
    #   :joins => "JOIN 'imentore_employees' ON imentore_employees.id = imentore_users.userable_id",
    #   :conditions => "imentore_users.email = 'cliente@myshop.com'")

    #   include SentientUser
    #
    #   # Soft delete.
    #   named_scope :not_deleted, :conditions => ['users.deleted_at IS NULL']
    #   named_scope :deleted, :conditions => ['users.deleted_at IS NOT NULL']
    #
    #   # before_save :skip_password
    #   #
    #   # def skip_password
    #   #   Rails.logger.debug { "message#{request.request.uri.include?("admin")} " }
    #   #
    #   # end
    #
    #   #attr_writer :skip_email, :skip_password
    #
    #   #acts_as_authorization_subject
    #
    #   #def require_email?
    #     #@skip_email.blank?
    #   #end
    #
    #   #def need_password?
    #     #@skip_password.blank? && require_password?
    #   #end
    #
    #   attr_accessor :skip_devise
    #   mattr_accessor :skip_logger, :authenticatable, :password_required, :store_created, :skip_validate_ird_national
    #
    #
    #   # if ENV['RAILS_ENV'] == "production"
    #     # devise :database_authenticatable, :confirmable, :recoverable, :rememberable, :trackable, :activatable, :validatable
    #     devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable
    #   # elsif ENV['RAILS_ENV'] == "development"
    #     # devise :database_authenticatable, :recoverable, :rememberable, :trackable, :activatable, :validatable
    #   # else
    #     # devise :database_authenticatable, :recoverable, :rememberable, :trackable, :activatable, :validatable
    #   # end

    # def store_id
    #   false
    # end
    #
    #   def password_required?
    #     # Rails.logger.debug { "aqui" }
    #     # Rails.logger.debug { "authen=>#{self.authenticatable}" }
    #     # Rails.logger.debug { "authen=>#{authenticatable}" }
    #     # self.authenticatable = true
    #   end
    #
    #   with_options :if => :password_required? do |v|
    #     # v.validates_presence_of     :password
    #     # v.validates_confirmation_of :password
    #     # v.validates_length_of       :password, :within => 6..20, :allow_blank => true
    #   end
    #
    #   has_many :lists,
    #     :class_name=>'WishList',
    #     :foreign_key=>'user_id'
    #
    #   has_many :logs,
    #     :as => :loggable,
    #     :validate => false
    #   has_one :address,
    #     :as=> :addressable,
    #     :order =>"id"
    #
    #
    #   has_many :addresses,
    #     :as => :addressable,
    #     :dependent => :destroy,
    #     :validate => false
    #
    #   has_many :orders
    #   #has_one :account
    #   #has_many :roles,
    #     #:as => :authorizable
    #   # validates_presence_of :email
    #   # validates_uniqueness_of :email, :scope => authentication_keys[1..-1], :allow_blank => true
    #   # validates_format_of :email, :with => Devise::EMAIL_REGEX, :allow_blank => true
    #
    #   # validates_presence_of :name, :email, :on => :save, :if => proc { |obj| Rails.logger.debug { "obj=> #{obj.inspect }"}; obj.create_demonstration == true }
    #
    #   validates_presence_of :name
    #   validates_presence_of :irs_id, :on => :create, :if => proc { |obj| obj.store_created == true }
    #   validates_presence_of :irs_id, :national_id, :on => :create, :if => proc { |obj| skip_validate_ird_national.nil? and   !obj.store.nil? and obj.store.settings.admin_virtual_require_ird_national_id == "1" }
    #   # validates_presence_of :national_id, :on => :create, :if => proc { |obj| obj.store_created == true && obj.type == "Person"}
    #   # validates_confirmation_of :email, :on => :create, :message => "should match confirmation" , :if => proc { |obj| obj.skip_logger == true }
    #
    #   before_create  :skip_confirmation, :type_capitalize
    #   after_create  :logger_not_default
    #
    #   accepts_nested_attributes_for :addresses#, :account
    #
    #   #def self.find_with_scope(store_id, role, *args)
    #     #with_scope(:find => { :joins => "INNER JOIN roles_users ON users.id = roles_users.user_id INNER JOIN roles ON roles_users.role_id = roles.id", :conditions => ["roles.authorizable_id =  ? AND roles.name = ?", store_id, role], :readonly => false }) do
    #       #find(*args)
    #     #end
    #   #end
    #
    #   # def birthdate
    #   #   read_attribute(:birthdate).to_date.strftime("%d-%m-%Y")
    #   #   # date = birthdate.to_date
    #   #   # date = Date.strptime({ date.year, date.month, date.day }, "{ %Y, %m, %d }")
    #   #   # uodate_attribute(:birthdate, date)
    #   # end
    #
    #
    #   def logger_not_default
    #     if self.skip_logger.nil?
    #       Log.logger(self, "#{I18n.t(self.role.downcase.to_sym)} #{self.name} - #{I18n.t(self.type.downcase.to_sym)} - #{I18n.t(:added)}")
    #     end
    #   end
    #
    #   def type_capitalize
    #     unless self.nil?
    #       self.type = self.type.capitalize
    #     end
    #   end
    #
    # #
    # # Methods when use with confirmable action is use
    # def skip_confirmation!
    #   true
    # end
    #
    # def confirm!
    #   true
    # end
    # # Methods when use with confirmable action is use
    #   #
    #
    #
    #   def skip_confirmation
    #     # if self.email == "admin@imentore.com.br" or (ENV['RAILS_ENV'] == "cucumber") or self.skip_devise == true
    #     if self.email == "admin@imentore.com.br" or self.skip_devise == true
    #       self.skip_confirmation!
    #       self.authenticatable = true
    #     end
    #   end
    #
    #   def has_role?(role, *args)
    #     role = "admin" if role.to_s == "owner"
    #     role.to_s == self.role
    #   end
    #
    #   def modules=(modules)
    #     self.modules_mask = (modules & Imentore.app.modules).map { |r| 2**Imentore.app.modules.index(r) }.sum
    #   end
    #
    #   def modules
    #     Imentore.app.modules.reject do |r|
    #       ((modules_mask || 0) & 2**Imentore.app.modules.index(r)).zero?
    #     end
    #   end
    #
    #   def admin?
    #     role == "admin"
    #   end
    #
    #   def employee?
    #     admin? || role == "employee"
    #   end
    #
    #   def can_access?(mod)
    #     case self.role
    #     when "admin" then true
    #     when "employee" then modules.include?(mod.to_s)
    #     else false
    #     end
    #   end
    #
    #   def restricted?
    #     !unrestricted?
    #   end
    #
  end
end
