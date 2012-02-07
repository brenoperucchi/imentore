require 'spec_helper'

describe Imentore::Admin::DashboardController do
  describe "#index" do
    it "renders index template" do
      get :index
      response.should render_template('index')
    end
  end
end