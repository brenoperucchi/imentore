module Imentore
  module Admin
    class SessionsController < Devise::SessionsController

      layout "admin"
      
      def after_sign_in_path_for(resource)
        (resource.userable.owner? || resource.userable.admin?) ? admin_dashboard_path : client_dashboard_path
      end

    end
  end
end