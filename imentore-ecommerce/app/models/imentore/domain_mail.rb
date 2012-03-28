module Imentore
	load  "~/app/imentore/imentore-ecommerce/lib/plesk.rb"

  class DomainMail < ActiveRecord::Base

  	has_many :domain_mail

  	belongs_to :store

  	def add_mail_domain_plesk
  	  return true unless hosting
  	  plesk = Imentore::Plesk.new
  	  response = plesk.add_mail_domain(plesk_id, name, password)
  	  update_attribute(:plesk_id, response.plesk_id) if response.plesk_id.present?
  	  errors.add :base, response.message if not response.success?
  	  return response.success?
  	end

  	def del_mail_domain_plesk
	    return true unless hosting
  	  plesk = Imentore::Plesk.new
  	  response = plesk.del_mail_domain(plesk_id, name)
  	  Rails.logger.debug { "response.inspect=>#{response.inspect}"}
  	  errors.add :base, response.message if not response.success?
  	  return response.success?
  	end


  end
end
