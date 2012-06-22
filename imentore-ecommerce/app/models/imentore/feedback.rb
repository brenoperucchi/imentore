module Imentore
  class Feedback < ActiveRecord::Base
    belongs_to :store
    belongs_to :feedbackable, polymorphic: true
  end
end