module Imentore
  module Client
    class BaseController < ::ApplicationController
      include Imentore::BaseHelper

      layout "client"

    end
  end
end
