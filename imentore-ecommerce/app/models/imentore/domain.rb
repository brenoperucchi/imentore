module Imentore
  load  "~/app/imentore/imentore-ecommerce/lib/plesk.rb"

  class Domain < ActiveRecord::Base
    belongs_to :store
    serialize :emails, Hash

    before_destroy :bf_destroy

    def bf_destroy
      if hosting and not plesk_id.nil?
        plesk = Imentore::Plesk.new
        response = plesk.del_domain(plesk_id)
        if not response.success?
          self.errors.add(:hosting, response.message)
          false
        end
      end
      return true
    end

  end
end

