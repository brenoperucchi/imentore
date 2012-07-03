module Imentore
  class NoticesController < BaseController

    def show
      @notice = current_store.notices.find_by_handle(params[:page])
    end
  end
end
