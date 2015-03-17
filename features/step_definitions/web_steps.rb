require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)

end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Given /^I fill in "(.*?)" as the "(.*?)"$/ do |text, id|
	fill_in id, :with => text
end

Given /^(?:I )click "(.*?)"$/ do |button_text|
	click_button button_text
end