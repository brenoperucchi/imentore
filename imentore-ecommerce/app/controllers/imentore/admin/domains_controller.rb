module Imentore
  module Admin
    class DomainsController < Admin::BaseController
      inherit_resources
      actions :index, :create, :destroy
      require 'pry'

      def emails
        @domain = current_store.domains.find(params[:id])
        plesk = Imentore::Plesk.new
        if request.post?
          response = plesk.add_mail_domain(@domain.plesk_id, params[:name], params[:password])
          if response.success?
            @domain.emails = @domain.emails.merge(params[:name] => response.plesk_id)
            @domain.save
          end
          @emails = @domain.emails
        elsif request.delete?
          response = plesk.del_mail_domain(@domain.plesk_id, params[:name])
          if response.success?
            @domain.emails.delete(params[:name])
            @domain.save
          end
        elsif request.put?
          response = plesk.change_mail_domain(@domain.plesk_id, params[:name], params[:password])
        end
        response.success? ? flash[:notice] = "Successfully on action" : flash[:notice] = "Error on action" if response
        # binding.pry
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
        destroy! do |success, failure|
          failure.html do 
            flash[:notice] = "Error on destroy domain"
            redirect_to admin_domains_path 
          end
          success.html do
            flash[:notice] = "Successfully on destroy domain"
            redirect_to admin_domains_path             
          end
        end
      end

      protected

      def begin_of_association_chain
        current_store
      end
    end
  end
end