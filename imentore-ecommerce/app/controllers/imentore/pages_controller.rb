module Imentore
  class PagesController < BaseController

    def show
      @page_normal = current_store.pages.find_by_handle(params[:page])
      @page = Imentore::ObjectDrop.new(@page_normal)
    end
  end
end
