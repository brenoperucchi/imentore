module Imentore
  module CMS
    class Engine < Rails::Engine
      isolate_namespace Imentore
      engine_name "imentore_cms"

      initializer "precompile vendor assets", group: :all do |app|
        app.config.assets.precompile += %w( vendor/assets/**/* )
      end

      config.to_prepare do
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_slice.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
    end
  end
end
