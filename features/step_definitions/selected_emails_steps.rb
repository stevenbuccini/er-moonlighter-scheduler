When /^I click the name "(.*)"$/ do |button_text|
  assert(true)
end

Given /^(?:I )click the button "(.*?)"$/ do |button_text|
  assert(false)
end

Then(/^the email should be sent to "(.*?)"$/) do |name|
  assert(false)
end

Then(/^the email should not be sent to "(.*?)"$/) do |name|
  assert(false)
end
