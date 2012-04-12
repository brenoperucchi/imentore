module Imentore
  module Admin
    class DomainsController < Admin::BaseController
      inherit_resources
      actions :index, :create, :destroy

      def index
        build_resource
        index!
      end

      def create
        @domain = current_store.domains.build(params[:domain])
        if @domain.hosting
          plesk = Imentore::Plesk.new
          response = plesk.add_domain(@domain.name)
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
        @domain = resource

        if @domain.hosting
          plesk = Imentore::Plesk.new
          response = plesk.del_domain(@domain.plesk_id)

          unless response.success?
            flash[:error] = "Erro apagando dominio. Tente mais tarde."
            redirect_to(admin_domains_path) and return
          end
        end

        destroy! { admin_domains_path }
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end
