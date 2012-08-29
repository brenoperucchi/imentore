module AdminImentore
  class AssetsController < AdminImentore::BaseController
    inherit_resources
    defaults :resource_class => AdminImentore::Asset, :collection_name => 'assets', :instance_name => 'asset'
    actions :new, :create, :destroy, :index
    belongs_to :theme, parent_class: AdminImentore::Theme

    respond_to :json, only: [:create, :index, :destroy]

    def index
      respond_with(collection.map { |asset| AdminImentore::AssetPresenter.new(asset).to_json })
    end

    def create
      create! do |success, failure|
        success.json {
          render json: [AdminImentore::AssetPresenter.new(@asset).to_json]
        }
      end
    end

    def destroy
      destroy! { false }
    end

  end
end

