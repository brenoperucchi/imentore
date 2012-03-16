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
      @current_store ||=
        Store.joins(:domains).where("imentore_domains.name" => request.domain).first ||
        Store.find_by_url(request.subdomain)
    end

    def check_store
      unless current_store
        render('shared/not_found', status: 404)
        return false
      end
    end
  end
end