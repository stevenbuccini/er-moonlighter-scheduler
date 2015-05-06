Given(/^a new user signup with name James Jones$/) do
  FactoryGirl.create(:user, :first_name => "James", :last_name => "Jones", :email => "jjones@example.com")
end


When(/^I approve Jame Jones to become a doctor$/) do
  pending # express the regexp above with the code you wish you had
end

# Then(/^I should see Jame Jones in the table of doctors$/) do
#   pending # page.contain(Jame Jones)
#   if page.respond_to? :should
#     page.should have_content(text)
#   else
#     assert page.has_content?(text)
#   end
# end

Given(/^a new user exists$/) do
  FactoryGirl.create(:user)
end

Given(/^I am signed in as a user awaiting admin approval$/) do
  visit '/users/login'
  fill_in 'user_email', :with => "newuser@example.com"
  fill_in 'user_password', :with => 11111111
  click_button 'Log in'
end

Given(/^I update my profile page$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am an existing doctor$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I sign in with my Login credentials$/) do
  pending # express the regexp above with the code you wish you had
end
When(/^I click on "(.*?)"$/) do |arg1|
  click_button arg1
end