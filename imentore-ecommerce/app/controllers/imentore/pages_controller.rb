module Imentore
  class PagesController < BaseController

    def show
      @page = current_store.pages.find_by_handle(params[:page])
    end
  end
end
