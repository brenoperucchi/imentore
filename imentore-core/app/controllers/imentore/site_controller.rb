module Imentore
  class SiteController < BaseController
    skip_before_filter :check_store

    before_filter :set_page

    def index
      
    end

    def show
    end

   def set_page
      @store = Imentore::Store.new
      @page = params[:page]
    end

  end
end
