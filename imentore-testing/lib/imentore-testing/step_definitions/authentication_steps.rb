When "I log in as MyShop's owner" do
  visit new_admin_session_url(host: "myshop.imentore.dev")
  fill_in('Email', with: 'owner@myshop.imentore.dev')
  fill_in('Password', with: '123123')
  click_button 'Sign in'
end

Given "I am a visitor" do
  visit destroy_user_session_url
end

Given "I am logged in as the owner" do
  visit new_admin_session_url(host: "myshop.imentore.dev")
  fill_in('Email', with: 'owner@myshop.imentore.dev')
  fill_in('Password', with: '123123')
  click_button 'Sign in'
  page.should have_content("dashboard")
end

Then "I should see the MyShop's dashboard" do
  page.should have_content("dashboard")
end