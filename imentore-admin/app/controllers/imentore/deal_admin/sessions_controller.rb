module Imentore
  module DealAdmin
    class SessionsController < Devise::SessionsController
      require  'pry'
      skip_before_filter :current_store, :check_store
      layout "deal"

      def after_sign_in_path_for(resource)
        deal_admin_dashboard_index_path if dealer_signed_in?
      end

      def after_sign_out_path_for(resource)
        deal_path
      end

    end
  end
end