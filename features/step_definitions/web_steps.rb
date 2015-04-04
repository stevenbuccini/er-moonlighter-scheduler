require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^(?:|I )should see "(.*)"$/ do |text|
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

Then /^(?:|I )should not see "(.*)"$/ do |text|
  if page.respond_to? :should
    page.should_not have_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then /^(?:|I )should be on (.*)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
  	current_path.should == path_to(page_name)
  else
  	assert_equal path_to(page_name), current_path
  end
end