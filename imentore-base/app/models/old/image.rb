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
   :database => 'go2b_development',
   :host     => 'localhost',
   :username => 'root',
   :password => '',
   :encoding => 'utf8',
   )
end
end