module Imentore
  class SiteController < BaseController
    skip_before_action :check_store
    skip_before_action :current_cart
    before_action :set_page

    before_action :check_is_logged

    def check_is_logged
      sign_out if user_signed_in?
    end

    def index
      
    end

    def show
    end

   def set_page
      @store = Imentore::Store.new
      @page = params[:page]
      if @page == 'register'
        @store.build_owner
        @store.owner.build_user
      end
    end

  end
end