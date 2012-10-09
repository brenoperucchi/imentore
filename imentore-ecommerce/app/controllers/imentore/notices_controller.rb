module Imentore
  class NoticesController < BaseController

    def show
      @notice_normal = current_store.notices.find_by_handle(params[:handle])
      @notice = Imentore::NoticeDrop.new(@notice_normal)
    end

  end
end
