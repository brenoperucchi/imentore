module Imentore
  # require 'plesk'
  load  "~/app/imentore/imentore-ecommerce/lib/plesk.rb"

  class Domain < ActiveRecord::Base
    # after_save :add_domain_plesk
    belongs_to :store

    def add_domain_plesk
      return true unless hosting
      plesk = Imentore::Plesk.new
      response = plesk.add_domain(name)
      update_attribute(:plesk_id, response.plesk_id) if response.plesk_id.present?
      errors.add :base, response.message if not response.success?
      return response.success?
    end

    def del_domain_plesk
        return true unless hosting
      plesk = Imentore::Plesk.new
      response = plesk.del_domain(plesk_id)
      Rails.logger.debug { "response.inspect=>#{response.inspect}"}
      errors.add :base, response.message if not response.success?
      return response.success?
    end

  end
end

