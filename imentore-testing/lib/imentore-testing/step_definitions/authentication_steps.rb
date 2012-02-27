Given "I am logged in as the MyShop's owner" do
  visit new_admin_session_url(host: "myshop.imentore.dev")
  fill_in('Email', with: 'owner@myshop.imentore.dev')
  fill_in('Password', with: '123123')
  click_button 'Sign in'
  page.should have_content("dashboard")
end