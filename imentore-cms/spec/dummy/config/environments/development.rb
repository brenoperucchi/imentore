Dummy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.log_level = :debug

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  ## RAILS 4
    # Log error messages when you accidentally call methods on nil.
    # config.whiny_nils = true
  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :debug

  ## RAILS 4
  config.active_record.migration_error = :page_load

  # Expands the lines which load the assets
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  
end
