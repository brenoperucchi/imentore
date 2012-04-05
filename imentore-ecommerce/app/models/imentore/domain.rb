module Imentore
  load  "~/app/imentore/imentore-ecommerce/lib/plesk.rb"

  class Domain < ActiveRecord::Base
    belongs_to :store
    serialize :emails, Hash
  end
end

