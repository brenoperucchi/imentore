require 'active_record/connection_adapters/abstract/schema_definitions'

require_relative 'personhood/schema'

module Personhood

  def person?
    person_type == "person"
  end

  def company?
    person_type == "company"
  end

  def self.included(base)
    base.class_eval do
      validates :person_type, inclusion: { in: %w(person company) }
      validates :name, presence: true
      validates :brand, presence: true, if: :company?
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Personhood::Schema)