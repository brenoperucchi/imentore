module Imentore
  module Client
    class RegistrationsController < Devise::RegistrationsController
      layout "client"


      def new
        # binding.pry
        # @customer = current_store.customers.new
      end

      # def create
      #   params[:user].merge!(store_id: current_store.id.to_s)
      #   super
      # end

      # def after_sign_in_path_for(resource)
      #   if session[:user_return_to] and session[:user_return_to].include?('checkout')
      #     checkout_path
      #   else
      #     (resource.userable.owner? || resource.userable.admin?) ? admin_dashboard_path : client_dashboard_path
      #   end
      # end

    end
  end
end