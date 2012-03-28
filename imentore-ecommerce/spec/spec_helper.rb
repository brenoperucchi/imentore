ENV["RAILS_ENV"] = 'test'

require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

require 'imentore-testing/spec_helper'
require 'webmock/test_unit'