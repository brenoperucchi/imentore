module Imentore
  module Admin
    class AssetsController < BaseController
      inherit_resources
      belongs_to :theme
      actions :new, :create, :destroy, :index

      respond_to :json, only: [:create, :index, :destroy]

      def index
        respond_with(collection.map { |asset| AssetPresenter.new(asset).to_json })
      end

      def create
        create! do |success, failure|
          success.json {
            render json: [AssetPresenter.new(@asset).to_json]
          }
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
