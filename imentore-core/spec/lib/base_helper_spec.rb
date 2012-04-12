require "spec_helper"
require "imentore-core/base_helper"

module Imentore

  class Request

    attr_accessor :domain, :subdomain
    def initialize
      @domain = "imentore.com"
      @subdomain = "myshop"
    end
  end

  class Includer < BaseController

    def initialize
      @request = Imentore::Request.new
    end

    def request
      @request
    end
  end

end

describe 'Imentore::BaseHelper' do
  before(:each) do
    Factory.create(:myshop)
  end

  it "current_store" do
    i = Imentore::Includer.new
    i.request.domain = "another-domain.com"
    i.current_store.should be_nil
  end

  it "current_store be exist" do
    i = Imentore::Includer.new
    i.request.domain = "imentore.com"
    i.current_store.should_not be_nil
  end

end