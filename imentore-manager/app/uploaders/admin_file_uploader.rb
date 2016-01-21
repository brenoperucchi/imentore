# encoding: utf-8
require 'carrierwave/processing/mime_types'

class AdminFileUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  process :set_content_type
  process :save_content_type_and_size_in_model

  def save_content_type_and_size_in_model
    model.content_type = file.content_type if file.content_type
  end

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.theme.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # process :resize_to_fit => [200, 200]

  # version :bigger do
  #   process :resize_to_fill => [900, 900]
  # end
  # version :big do
  #   process :resize_to_fill => [600, 600]
  # end
  # version :larger do
  #   process :resize_to_fill => [300, 300]
  # end
  # version :medium do
  #   process :resize_to_fill => [200, 200]
  # end
  # version :small do
  #   process :resize_to_fill => [150, 150]
  # end
  # version :thumb do
  #   process :resize_to_fill => [100, 100]
  # end
  # version :mini_thumb do
  #   process :resize_to_fill => [75, 75]
  # end
  version :super_thumb, :if => :is_picture? do
    process :resize_to_fill => [50, 50]
  end

  protected

  def is_picture?(picture)
    return false if set_content_type(picture).include?('svg')
    set_content_type(picture).include?('image')
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
