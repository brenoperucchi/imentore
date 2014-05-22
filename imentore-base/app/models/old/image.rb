# encoding: utf-8
module Old
  class Image < ActiveRecord::Base

    def self.table_name
      "images"
    end

    belongs_to :imageable, :polymorphic => true

    has_attached_file :picture,
      :url => "/system/images/:id_partition/:basename_:style.:extension",
      :path => ":rails_root/public/system/images/:id_partition/:basename_:style.:extension",
      :default_url => "/images/missing_image.png"

    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :encoding => 'latin1',
     :database => 'go2b_production',
     :host     => 'app.imentore.com.br',
     :username => 'go2b',
     :password => 'app0p..za'
     )
  end
end