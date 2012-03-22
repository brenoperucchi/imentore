require 'spec_helper'

describe Imentore::Domain do
  let(:domain) { Imentore::Domain.new}
  # let(:domain_name) { 'test.com'}
  let(:domain_name) { 'test' + rand(10).to_s + '.com'}

  it { should belong_to :store }

  it "can add a domain in plesk api" do
    domain.name = domain_name
    domain.hosting = true
    domain.save
    @@result = domain.add_domain_plesk
    # puts "result => #{@@result.inspect}"
    # @@result.should be  == "ok"
  end

  it "delete domain in plesk_api" do
    # puts "del result => #{@@result.inspect}"
    result = @@result.del_domain_plesk
    # result.should be  == "ok"
  end


  # it { should have_many :urls }
  # it { should have_many :employees }
  # it { should have_many :customers }
  # it { should have_many :suppliers }
end