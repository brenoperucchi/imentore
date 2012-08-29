module Imentore
  module Deal
    class TalentsController < BaseController
    require 'pry'
      inherit_resources
      # belongs_to :user, parent_class: Imentore::Dealer
      skip_before_filter :check_store, :authorize_admin, :current_cart, :current_store

      def new
        @user_deal = Imentore::Dealer.new
        # binding.pry
        new!
      end

      def create
        create! { deal_path }
      end

      # def begin_of_association_chain
      #   current_user
      # end

    end
  end
end