When(/^(?:|I )fill in the following users$/) do |fields|
	fields.rows_hash.eash do |first, last, email, type|
		When %{I fill in "#{name}" with "#{value}"}
	end
end

When /^(?:I )fill in "([^"]*)" with "([^?]*)"$/ do |field,value|
	fill_in(field, :with => value)
end

Given /^(?:|I ) am on (.+)$/ do |page_name|
	visit path_to(page_name)
end