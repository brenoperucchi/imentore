module Imentore
  class BaseController < ::ApplicationController
    include Imentore::BaseHelper

    layout "public"
  end
end
