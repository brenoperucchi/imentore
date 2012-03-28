require 'spec_helper'

describe Imentore::Domain do
  let(:domain) { Imentore::Domain.new}
  # let(:domain_name) { 'test.com'}
  let(:domain_name) { 'test' + rand(10).to_s + '.com'}

  it { should belong_to :store }

  it "can add a domain in plesk api" do
    domain.name = domain_name
    domain.hosting = true
    result = domain.add_domain_plesk
    result.should be_true
    @@domain = domain.save
  end

  it "delete domain in plesk_api" do
    result = @@domain.del_domain_plesk
    result.should be_true
  end


  # it { should have_many :urls }
  # it { should have_many :employees }
  # it { should have_many :customers }
  # it { should have_many :suppliers }
end