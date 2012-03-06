module Imentore
  class BaseController < ApplicationController
  	before_filter :check_store

  	helper_method :current_store

  	def current_store

  	  @current_store ||= if Imentore::Store.find_by_url(request.subdomain).present?
                            Imentore::Store.find_by_url(request.subdomain)
                          else
                            Imentore::Domain.find_by_name(request.domain).store
                          end
  	end

  	def check_store
  	  unless current_store
  	    render('shared/not_found', status: 404)
  	    return false
  	  end
  	end

  end
end