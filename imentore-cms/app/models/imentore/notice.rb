module Imentore
  class Notice < ActiveRecord::Base
    scope :active, where(active: true)
  end
end