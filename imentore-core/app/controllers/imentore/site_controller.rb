module Imentore
  class SiteController < BaseController
    skip_before_filter :check_store

    def show
    end

  end
end
