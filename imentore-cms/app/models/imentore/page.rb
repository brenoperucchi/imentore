module Imentore
  class Page < ActiveRecord::Base
    belongs_to :store

    def handle=(param)
      write_attribute(:handle, param.to_underscore!)
    end
  end
end
