module Imentore
  module Admin
    class ImagesController < BaseController
      inherit_resources
      belongs_to :variant, parent_class: Imentore::ProductVariant

      respond_to :json, only: [:create, :index, :destroy, :new]

      def index
        respond_with(collection.map { |image| Imentore::ImagePresenter.new(image).to_json })
      end

      def create
        create! do |success, failure|
          success.json {
            render json: [Imentore::ImagePresenter.new(@image).to_json]
          }
        end
      end

    end
  end
end
