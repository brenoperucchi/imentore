module Imentore
  class AssetFolder < ActiveRecord::Base
    has_ancestry cache_depth: true

    validates :name, presence: true
    validates :name, format: { with: /\A[a-zA-Z]+\z/ }
    
    has_many :assets, :class_name => "Imentore::Asset", :foreign_key => "folder_id", :dependent => :destroy
    belongs_to :store, :class_name => Imentore::Store, :foreign_key => "store_id"
    belongs_to :theme, :class_name => Imentore::Theme, :foreign_key => "theme_id"

    # accepts_nested_attributes_for :assets

  end
end