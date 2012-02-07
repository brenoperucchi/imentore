# Point RAILS_ROOT to the dummy app
ENV['RAILS_ROOT'] = File.expand_path(File.dirname(__FILE__) + '/../../spec/dummy/')

require 'cucumber/rails'
require 'database_cleaner'
require 'factory_girl_rails'
require 'pry'

# Every exception will make the feature fail
ActionController::Base.allow_rescue = false

DatabaseCleaner.strategy = :truncation