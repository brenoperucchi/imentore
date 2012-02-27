require "spec_helper"

describe Imentore::Theme do
  it { should respond_to(:name) }
  it { should belong_to(:store) }
end