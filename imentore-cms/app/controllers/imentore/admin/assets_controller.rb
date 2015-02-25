module Imentore
  module Admin
    class AssetsController < BaseController
      # inherit_resources
      # actions :new, :create, :destroy, :index
      # belongs_to :theme
      respond_to :html, :json, only: [:create, :index, :destroy]
      # skip_before_filter :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}

      def index
        @theme = current_store.themes.find(params[:theme_id])
        collection = @theme.assets
        respond_with(files: collection.map {|asset| Imentore::AssetPresenter.new(asset).to_json})
      end

      def create
        @asset = current_store.themes.find(params[:theme_id]).assets.new(params[:asset])
        respond_to do |format|
          if @asset.save
            format.json {
              render json:{files: [Imentore::AssetPresenter.new(@asset).to_json]}, status: :created 
            }
          end
        end
      end

      def destroy
        @asset = current_store.themes.find(params[:theme_id]).assets.find(params[:id]).destroy
        respond_with @asset.destroy
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
