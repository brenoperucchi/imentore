module Imentore
  class Page < ActiveRecord::Base
    belongs_to :store

    validates :name, :handle, presence: true
    validates :handle, uniqueness: { scope: :store_id }
    validates :handle, format: { with: /[a-z]+[-a-z]+[a-z]+/ }


    def handle=(param)
      write_attribute(:handle, param.to_underscore!)
    end
  end
end
