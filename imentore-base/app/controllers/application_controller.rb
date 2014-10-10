class ApplicationController < ActionController::Base
  protect_from_forgery

  after_filter :logger

  def logger
    Rails.logger.info { "Remote  IP : #{request.remote_ip}" }
    Rails.logger.info { "Request URL: #{request.referrer}" }
  end

end