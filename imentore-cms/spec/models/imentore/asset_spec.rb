require "spec_helper"

describe Imentore::Asset do
  it { should belong_to(:asset) }
end