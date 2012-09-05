module Imentore
  module Client
    class DashboardController < Client::BaseController
      skip_before_filter :check_store, :authorize_client, :current_cart, :only=>[:key_session]
      skip_before_filter :verify_authenticity_token#, :if => Proc.new { |c| c.request.format == 'application/json' }
      respond_to :json

      def index

      end

      # def key_session
      #   if not(params[:key] == "key_nav") or not(params[:key] == "key_bar")
      #     if request.post?
      #       respond_to do |wants|
      #         wants.json do
      #         session[params[:key]] = params[:value].to_s
      #         render :status => 200, :json => {'success' => 'ok'}
      #         end
      #       end
      #     elsif request.get?
      #       respond_to do |wants|
      #         wants.json do
      #           session[params[:key]] ||= 'dashboard'
      #           render :status => 200, :json => { params[:key] => session[params[:key]] }
      #         end
      #       end
      #     end
      #   else
      #     render :nothing => true
      #   end
      # end
    end
  end
end