module Personhood
  module Schema
    def personhood
      apply_schema(:name, :string)
      apply_schema(:brand, :string)
      apply_schema(:irs_id, :string)
      apply_schema(:birthdate, :date)
      apply_schema(:national_id, :string)
      apply_schema(:gender, :string)
      apply_schema(:person_type, :string)
    end

    def apply_schema(name, type, options = {})
      column name, type, options
    end
  end
end