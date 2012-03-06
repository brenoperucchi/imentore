module Imentore
  class Domain < ActiveRecord::Base
    belongs_to :store
  end
end