# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require "bundler/setup"
require File.expand_path("../dummy/config/environment",  __FILE__)
require "rspec/rails"
require 'rspec/autorun'
require 'pry'

Bundler.require(:default, :test)

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
require "capybara/rspec"
Capybara.javascript_driver = :webkit

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end