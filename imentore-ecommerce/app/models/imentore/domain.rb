module Imentore
  # require 'plesk'
  load  "~/app/imentore/imentore-ecommerce/lib/plesk.rb"

  class Domain < ActiveRecord::Base
    # after_save :add_domain_plesk
    belongs_to :store

    def hosting?
      true if plesk_id.present?
    end

    def add_domain_plesk
      return unless hosting
      plesk = Imentore::Plesk.new
      result = plesk.add_domain(name)
      return false if result.status != "ok"
      update_attribute(:plesk_id, result.plesk_id)
      return self
    end

    def del_domain_plesk
      return unless hosting
      plesk = Imentore::Plesk.new
      result = plesk.del_domain(plesk_id)
      return false if result.status != "ok"
      return self
    end

  end
end

