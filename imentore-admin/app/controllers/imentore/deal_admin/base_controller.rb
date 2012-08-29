# module Imentore
#   module DealAdmin
#     class BaseController < ::ApplicationController
#       before_filter :authenticate_dealer!
#       # layout "deal"
#       # before_filter :authenticate_dealer!
#      # before_filter :authorize_admin

#      #  def authorize_admin
#      #    unless(user_signed_in? && current_user.userable.owner?)
#      #     redirect_to(deal_admin_dashboard_index_url, alert: t(:permission_denied))
#      #    end
#      #  end
#     end

#   end
# end

# Imentore::DealAdmin::BaseController.class_eval do
#   before_filter :authorize_admin

#   def authorize_admin
#     unless(user_signed_in? && current_user.userable.owner?)
#       redirect_to(root_url, alert: t(:permission_denied))
#     end
#   end
# end

module Imentore
  module DealAdmin
    class BaseController < ::ApplicationController
      include Imentore::Core::Engine.routes.url_helpers
      before_filter :authenticate_dealer!
      layout "deal"
    end
  end
end