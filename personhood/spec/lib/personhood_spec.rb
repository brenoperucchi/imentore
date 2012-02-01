require 'spec_helper'

describe Personhood do
  it "adds migration helper" do
    table_definition = ActiveRecord::ConnectionAdapters::TableDefinition
    table_definition.should include(Personhood::Schema)
  end

  describe "#personhood table definition" do
    it "adds name, brand, irs_id, national_id, gender and person_type as string" do
      cols = %w{ name brand irs_id national_id gender person_type }
      model_columns = User.columns_hash
      cols.each do |col|
        model_columns[col].type.should eq(:string)
      end
    end

    it "adds birthdate as date" do
      User.columns_hash['birthdate'].type.should eq(:date)
    end
  end

  let(:user) { User.new }

  describe "validations" do
    it do
      user.should validate_presence_of(:name)
      user.should allow_value("person").for(:person_type)
      user.should allow_value("company").for(:person_type)
      user.should_not allow_value("duck").for(:person_type)
    end

    it "validates brand if company" do
      user.person_type = "company"
      user.valid?
      user.errors[:brand].should have(1).item
      user.errors[:brand].first.should eq("can't be blank")
    end
  end

end