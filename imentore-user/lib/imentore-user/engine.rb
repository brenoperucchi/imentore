module ApplicationControllerDecorator
  def after_sign_in_path_for(resource)
    'http://google.com'
  end
end

module ImentoreUser
  class Engine < Rails::Engine
    config.to_prepare do
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_slice.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    # initializer 'myengine.app_controller' do |app|
    #   ApplicationController.send(:include, ApplicationControllerDecorator)
    # end
  end
end