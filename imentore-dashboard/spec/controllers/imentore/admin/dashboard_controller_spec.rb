require 'spec_helper'

describe Imentore::Admin::DashboardController do
  describe "#index" do
    it "renders index template" do
      subject.stub(check_store: true)
      get :index
      response.should render_template('index')
    end
  end
end