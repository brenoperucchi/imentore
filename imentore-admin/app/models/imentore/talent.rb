module Imentore
  class Talent < ActiveRecord::Base
    belongs_to :dealer, :class_name => "Dealer", :foreign_key => "dealer_id"

  end
end