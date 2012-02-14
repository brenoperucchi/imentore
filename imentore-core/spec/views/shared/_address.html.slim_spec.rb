require "spec_helper"

describe "_address" do
  let(:helper) { Object.new.extend(ActionView::Helpers::FormHelper) }

  it "displays the address form" do
    pending
    address = Imentore::Address.new
    form = SimpleForm::FormBuilder.new(:user, mock(:user, address: address), helper, {}, nil)
    render 'shared/address', locals: { form: form }
  end
end