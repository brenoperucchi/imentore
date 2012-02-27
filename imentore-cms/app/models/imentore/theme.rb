module Imentore
  class Theme < ActiveRecord::Base
    belongs_to :store
  end
end