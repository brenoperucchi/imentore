module Imentore
  class Notice < ActiveRecord::Base
    belongs_to :store

    validates :name, presence: true
    validates :handle, uniqueness: { scope: :store_id }
    # validates :handle, format: { with: /^[-A-Za-z\d_]+$/ }
    scope :active, where(active: true)

    def handle
      return if read_attribute(:name).blank?
      if read_attribute(:handle).blank? 
        self.handle = name.to_underscore
        read_attribute(:handle)
      else 
        read_attribute(:handle)
      end
    end

    def handle=(param)
      write_attribute(:handle, param.to_underscore!)
    end
  end
end