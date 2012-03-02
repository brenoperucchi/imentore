module Imentore
  class Theme < ActiveRecord::Base
    belongs_to :store
    has_many :templates
  end
end