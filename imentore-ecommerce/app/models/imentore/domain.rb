module Imentore
  class Domain < ActiveRecord::Base
    belongs_to :store
    serialize :emails, Hash
  end
end
