module Imentore
  class BaseController < ::ApplicationController
    include Imentore::Core::Engine.routes.url_helpers

  	before_filter :check_store

  	helper_method :current_store

  	def current_store
      @current_store ||=
        Store.joins(:domains).where("domains.name" => request.domain).first ||
        Store.find_by_url(request.subdomain)
  	end

    protected

  	def check_store
  	  unless current_store
  	    render('shared/not_found', status: 404)
  	    return false
  	  end
  	end
  end
end