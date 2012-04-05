require 'spec_helper'

describe Imentore::Domain do
  let(:domain) { Imentore::Domain.new(emails: {a: 1, b: 2, c: 3}) }
  let(:domain_name) { 'test' + rand(10).to_s + '.com'}
  
  it { should belong_to :store }

  it "deserialize" do
    domain.save
    domain.reload.emails.should eq({a: 1, b: 2, c: 3})
  end

  it "destroy domain" do
    domain.hosting = true
    domain.save
    domain.destroy
    Imentore::Domain.find(1).shouldwww be_nil
  end

end