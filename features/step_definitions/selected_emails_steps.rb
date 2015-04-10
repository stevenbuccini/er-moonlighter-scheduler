Then(/^the email should be sent to "(.*?)"$/) do |name|

end

Then(/^the email should not be sent to "(.*?)"$/) do |name|

end

When(/^I select "(.*?)"$/) do |arg1|

end

When /^(?:|I )press "([^\"]*)"$/ do |button|
  click_button(button)
end