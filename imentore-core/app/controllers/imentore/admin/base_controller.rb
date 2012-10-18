module Imentore
  module Admin
    class BaseController < ::ApplicationController
      include Imentore::BaseHelper
      helper_method :sort_column, :sort_direction
      layout "admin"

      private
        
      def sort_column
        Imentore::Product.column_names.include?(params[:sort]) ? params[:sort] : "id"
      end
      
      def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
      end

    end
  end
end