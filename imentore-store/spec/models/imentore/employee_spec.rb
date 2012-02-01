require 'spec_helper'

describe Imentore::Employee do
  it { should belong_to(:store) }
  it { should validate_presence_of(:department) }
  it { should have_one(:user) }
end