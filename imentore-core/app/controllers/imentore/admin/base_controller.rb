module Imentore
  module Admin
    class BaseController < ::ApplicationController
      include Imentore::BaseHelper

      layout "admin"
    end
  end
end