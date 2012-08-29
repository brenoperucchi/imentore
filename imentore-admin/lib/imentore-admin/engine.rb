module AdminImentore
  module Admin
    class Engine < Rails::Engine
      # isolate_namespace AdminImentore
      engine_name "imentore_admin"

      config.to_prepare do
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_slice.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
    end
  end
end
