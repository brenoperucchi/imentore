require "spec_helper"

describe 'Imentore::BaseHelper' do
  let(:controller) { Imentore::BaseController.new }

  before(:each) do
    Factory.create(:myshop)
  end

  it "current_store" do
    controller.stub_chain(:request, :domain).and_return("another-domain.com")

    controller.current_store.should be_nil
  end

  it "current_store be exist" do
    controller.stub_chain(:request, :domain).and_return("imentore.com")
    controller.stub_chain(:request, :subdomain).and_return("myshop")

    controller.current_store.should be_a(Imentore::Store)
  end

end
