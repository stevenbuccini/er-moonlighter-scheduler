When(/^I sign up with username "(.*)" and password (\d+)$/) do |arg1, arg2|
  visit '/users/sign_up'
  fill_in 'user_email', :with => arg1
  fill_in 'user_password', :with => arg2
  click_button 'Sign up'
end

Then(/^I should be routed to edit info page$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^I should be taking to the doctor's login page$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am signed in as a doctor$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I try to visit the admin homepage$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am an existing admin$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should be taking to the admin's login page$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am signed in as an admin$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I try to visit the doctor's homepage$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a notice You are not authorised to view Doctor's page$/) do
  pending # express the regexp above with the code you wish you had
end
