class ApplicationController < ActionController::Base
  add_flash_types :error, :success
  

  protect_from_forgery

  after_filter :logger

  def logger
    Rails.logger.info { "Remote  IP : #{request.remote_ip}" }
    Rails.logger.info { "Request URL: #{request.referrer}" }
  end

end