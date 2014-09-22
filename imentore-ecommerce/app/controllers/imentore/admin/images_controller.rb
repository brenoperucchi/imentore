module Imentore
  module Admin
    class ImagesController < BaseController
      inherit_resources
      belongs_to :variant, parent_class: Imentore::ProductVariant
      skip_before_filter :verify_authenticity_token, :if => Proc.new {|c| c.request.format == 'application/json'}

      respond_to :json, only: [:create, :index, :destroy, :new]

      def index
        respond_with(files: collection.map {|image| Imentore::ImagePresenter.new(image).to_json})
      end

      def create
        create! do |success, failure|
          success.json {
            render json:{files: [Imentore::ImagePresenter.new(@image).to_json]}, status: :created 
          }
        end
      end

    end
  end
end
