module Imentore
  class Template < ActiveRecord::Base
    include ApplicationHelper
    belongs_to :theme

    def head
      if read_attribute(:head).nil?
        str = ""
        theme.assets.each do |asset|
          str << theme_include(asset.read_attribute(:file), asset.file_url)
        end
      end
      return str
    end

  end
end