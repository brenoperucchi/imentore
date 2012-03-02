require "spec_helper"

describe Imentore::Template do
  it { should respond_to(:path) }
  it { should respond_to(:body) }
  it { should respond_to(:partial) }
  it { should respond_to(:layout) }
  it { should respond_to(:format) }
  it { should respond_to(:locale) }
  it { should respond_to(:handler) }
  it { should respond_to(:updated_at) }
  it { should belong_to(:theme) }
end