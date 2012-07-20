module Imentore
  class Notice < ActiveRecord::Base
    scope :active, where(active: true)


    def handle=(param)
      write_attribute(:handle, param.to_underscore!)
    end
  end
end