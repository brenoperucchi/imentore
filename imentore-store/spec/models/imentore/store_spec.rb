require 'spec_helper'

describe Imentore::Store do

  # it { should have_one :address }
  # it { should have_many :urls }
  # it { should have_many :employees }
  # it { should have_many :customers }
  # it { should have_many :suppliers }

  it { should validate_presence_of(:brand) }
  it { should validate_presence_of(:url) }
  it do
    Imentore::Store.create(brand: 'Store', url: 'url')
    should validate_uniqueness_of(:url)
  end
  it { should allow_value('valid').for(:url) }
  it { should allow_value('v4l1d').for(:url) }
  it { should_not allow_value('1nvalid').for(:url) }
  it { should_not allow_value('invalid-').for(:url) }
  it { should ensure_length_of(:url).is_at_most(63) }
  it { should_not allow_value('www').for(:url) }
  # it { should validate_acceptance_of(:contract_term) }
  it { should have_many(:employees) }
  it { should have_one(:owner) }
  it { should respond_to(:config) }
  it { should respond_to(:name) }
  it { should respond_to(:irs_id) }
  it { should respond_to(:national_id) }
  it { should have_one(:address) }
end