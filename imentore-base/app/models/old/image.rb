# encoding: utf-8
module Old
  class Image < ActiveRecord::Base

    def self.table_name
      # "images"
      "imentore_images"
    end

    belongs_to :imageable, :polymorphic => true
    mount_uploader :picture, PictureUploader

    # has_attached_file :picture,
    #   :url => "/system/images/:id_partition/:basename_:style.:extension",
    #   :path => ":rails_root/public/system/images/:id_partition/:basename_:style.:extension",
    #   :default_url => "/images/missing_image.png"

    # self.abstract_class = true
    #  establish_connection(
    #  :adapter  => 'mysql2',
    #  :database => 'go2b_production',
    #  :host     => 'app.imentore.com.br',
    #  :username => 'imentoreapp',
    #  :password => 'app0p..za'
    #  )
    self.abstract_class = true
     establish_connection(
     :adapter  => 'mysql2',
     :database => 'imentore2',
     :host     => 'dns.imentore.com.br',
     :username => 'imentore2',
     :password => '123123'
     )

  end
end