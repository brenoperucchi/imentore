module Imentore
  class Template < ActiveRecord::Base
    belongs_to :theme
  end
end
