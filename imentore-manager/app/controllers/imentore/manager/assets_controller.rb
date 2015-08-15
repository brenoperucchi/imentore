module Imentore 
  module Manager
    class AssetsController < Imentore::Manager::BaseController
      inherit_resources
      defaults :resource_class => Imentore::Manager::Asset, :collection_name => 'assets', :instance_name => 'asset'
      actions :new, :create, :destroy, :new
      belongs_to :theme, parent_class: Imentore::Manager::Theme

      respond_to :json, only: [:create, :destroy, :new]

      def new
        @theme = Imentore::Manager::Theme.find(params[:theme_id])
        collection = @theme.assets
        respond_with(files: collection.map {|asset| Imentore::Manager::AssetPresenter.new(asset).to_json})
      end

      def create
        @asset = Imentore::Manager::Theme.find(params[:theme_id]).assets.new(asset_params)
        respond_to do |format|
          if @asset.save
            format.json {
              render json:{files: [Imentore::Manager::AssetPresenter.new(@asset).to_json]}, status: :created 
            }
          end
        end
      end


      # def index
      #   respond_with(collection.map { |asset| Imentore::Manager::AssetPresenter.new(asset).to_json })
      # end

      # def create
      #   create! do |success, failure|
      #     binding.pry
      #     success.json {
      #       render json: [Imentore::Manager::AssetPresenter.new(@asset).to_json]
      #     }
      #   end
      # end

      def destroy
        destroy! { false }
      end

      protected
      def asset_params
        params.require(:asset).permit(:file)
      end

    end
  end
end