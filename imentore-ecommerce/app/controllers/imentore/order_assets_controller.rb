module Imentore
    class OrderAssetsController < BaseController
      inherit_resources
      defaults :resource_class => Imentore::OrderAsset, :collection_name => 'assets', :instance_name => 'asset'
      belongs_to :order, parent_class: Imentore::Order

      respond_to :json, only: [:create, :index, :destroy, :new]

      def index
        respond_with(collection.map { |asset| Imentore::OrderAssetPresenter.new(asset).to_json })
      end

      def create
        create! do |success, failure|
          success.json {
            render json: [Imentore::OrderAssetPresenter.new(@asset).to_json]
          }
        end
      end
    end
end
