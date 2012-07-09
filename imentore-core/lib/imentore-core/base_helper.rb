module Imentore
  module BaseHelper
    def self.included(base)
      base.class_eval do
        include Imentore::Core::Engine.routes.url_helpers
        before_filter :check_store
        helper_method :current_store
      end
    end

    def current_store
      if request.domain.nil?
        @current_store = nil
      else        
        host = request.host.split(".")
        subdomain = host.first
        host.delete_at(0)
        domain = host.join('.')
        @current_store ||=
          Store.joins(:domains).where("imentore_domains.name" => request.host).first ||
          (Store.find_by_url(subdomain) if Imentore.config.domain.include?(domain))
      end
      @current_store
    end

    def check_store
      unless current_store
        redirect_to site_path
      end
      # unless current_store
      #   render('shared/not_found', status: 404)
      #   return false
      # end
    end

  end
end
