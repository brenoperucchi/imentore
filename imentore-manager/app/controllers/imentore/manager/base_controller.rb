module Imentore
  module Manager
    class BaseController < ::ApplicationController
      include Imentore::BaseHelper
      layout "manager"

    end
  end
end