module Imentore
  module Client
    class SessionsController < Devise::SessionsController
      # layout "client"

      def after_sign_in_path_for(resource)
        if session[:user_return_to] and session[:user_return_to].include?('checkout')
          address_checkout_path
        else
          (resource.userable.owner? || resource.userable.admin?) ? admin_dashboard_path : client_dashboard_path
        end
      end
    end
  end
end
