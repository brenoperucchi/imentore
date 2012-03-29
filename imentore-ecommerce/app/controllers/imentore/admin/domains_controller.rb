module Imentore
  module Admin
    class DomainsController < Admin::BaseController
      inherit_resources
      actions :index, :create, :destroy

      def emails
        @domain = current_store.domains.find(params[:id])
        @emails = @domain.emails
      end

      def index
        build_resource
        index!
      end

      def create
        @domain = current_store.domains.build(params[:domain])
        if @domain.hosting
          plesk = Imentore::Plesk.new
          response = plesk.add_domain(name)
          if response.success?
            @domain.plesk_id = response.plesk_id
          else
            @domain.errors.add(:hosting, response.message)
          end
        end

        if @domain.errors.empty?
          create! { admin_domains_path }
        else
          render :new
        end
      rescue Imentore::PleskException => e
        flash[:notice] = e.message
        redirect_to admin_domains_path
      end

      def destroy
        @domain = current_store.domains.find(params[:id])
        if @domain.del_domain_plesk
          destroy! { admin_domains_path }
        else
          flash[:notice] = @domain.errors.full_messages.first
          redirect_to admin_domains_path
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end