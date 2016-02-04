require 'spec_helper'

describe Imentore::Settings do
  let(:subject) { Imentore::Settings }

  it { should include(Imentore::Settings::Virtual) }
end