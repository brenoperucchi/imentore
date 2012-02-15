require 'spec_helper'

describe Imentore::Settings::Virtual do
  let(:subject) do
    Imentore::Settings.new
  end

  it "has default theme" do
    subject.theme.should eq(:default)
  end
end