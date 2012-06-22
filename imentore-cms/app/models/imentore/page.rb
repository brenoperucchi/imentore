module Imentore
  class Page < ActiveRecord::Base
    belongs_to :store
  end
end
