module Imentore
  module Admin
    class AssetsController < BaseController
      inherit_resources
      actions :new, :create, :destroy, :index
      belongs_to :theme
      respond_to :json, only: [:create, :index, :destroy]

      def index
        respond_with(collection.map { |asset| Imentore::AssetPresenter.new(asset).to_json })
      end

      def create
        create! do |success, failure|
          success.json {
            render json: [Imentore::AssetPresenter.new(@asset).to_json]
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
