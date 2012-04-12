Given "there is a store" do
  @store = Factory.create(:myshop)
end

Given "I am on its home page" do
  visit root_url(host: "#{@store.url}.imentore.dev")
end
