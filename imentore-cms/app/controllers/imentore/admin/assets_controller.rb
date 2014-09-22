module Imentore
  module Admin
    class AssetsController < BaseController
      inherit_resources
      actions :new, :create, :destroy, :index
      belongs_to :theme
      respond_to :json, only: [:create, :index, :destroy]
      skip_before_filter :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}

      def index
        respond_with(files: collection.map {|asset| Imentore::AssetPresenter.new(asset).to_json})
      end

      def create
        create! do |success, failure|
          success.json {
            render json:{files: [Imentore::AssetPresenter.new(@asset).to_json]}, status: :created 
          }
        end
      end

      def destroy
        destroy! { admin_theme_path(@theme) }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
