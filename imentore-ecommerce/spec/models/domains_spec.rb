require 'spec_helper'

describe Imentore::Domain do
  it { should belong_to :store }
  # it { should have_many :urls }
  # it { should have_many :employees }
  # it { should have_many :customers }
  # it { should have_many :suppliers }
end