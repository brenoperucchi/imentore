# require "bundler/setup"
require "pry"

# Bundler.require(:default, :test)

# ActionMailer::Base.delivery_method = :test
# ActionMailer::Base.perform_deliveries = true
# ActionMailer::Base.default_url_options[:host] = "test.com"

# SHOUT! http://guides.rubyonrails.org/2_3_release_notes.html#quieter-backtraces
Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
require "capybara/rspec"
Capybara.javascript_driver = :webkit

require "database_cleaner"
DatabaseCleaner.strategy = :transaction

require "shoulda-matchers"

require "imentore-testing/factories"

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.start
    Capybara.reset_sessions!
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # DatabaseCleaner will handle the transactions
  # We'll use :truncation only for Cucumber and Capybara w/ js: true
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = true
end