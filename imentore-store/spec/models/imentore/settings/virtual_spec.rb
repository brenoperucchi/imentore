require 'spec_helper'

describe Imentore::Settings::Virtual do
  let(:subject) do
    subject = Object.new
    subject.class_eval { include(Imentore::Settings::Virtual) }
    subject
  end

  it { should respond_to(:public_access) }
end