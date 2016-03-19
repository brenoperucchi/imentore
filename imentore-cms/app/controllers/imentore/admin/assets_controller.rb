module Imentore
  module Admin
    class AssetsController < BaseController
      # inherit_resources
      # actions :new, :create, :destroy, :index
      # belongs_to :theme
      respond_to :html, :json, :js, only: [:create, :index, :destroy, :new]
      # skip_before_action :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}

      def new
        @folder = current_store.folders.find(params[:asset_folder_id]) 
        @theme = @folder.theme
        @assets = @folder.assets
        @asset = Imentore::Asset.new
      end

      def index
        @theme = current_store.themes.find(params[:theme_id])
        @folder = @theme.folders.find(params[:asset_folder_id])
        @assets = @folder.assets
        @asset = Imentore::Asset.new
        # respond_with(files: collection.map {|asset| Imentore::AssetPresenter.new(asset).to_json})
        respond_with(@assets)
      end

      def create
        @theme = current_store.themes.find(params[:theme_id])
        @asset = @theme.assets.new(asset_params.merge(theme: @theme))
        respond_to do |format|
          if @asset.save
            format.json {
              render json:{files: [Imentore::AssetPresenter.new(@asset).to_json]}, status: :created 
            }
          end
        end
      end

      def destroy
        @theme = current_store.themes.find(params[:theme_id])
        @folder = @theme.folders.find(params[:asset_folder_id])
        @asset = @folder.assets.find(params[:id]).destroy
        @assets = @folder.assets
        respond_with @assets
      end

      protected

      def begin_of_association_chain
        current_store
      end

      def asset_params
        params.require(:asset).permit(:file, :folder_id)
      end
    end
  end
end
