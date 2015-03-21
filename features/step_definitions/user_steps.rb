def add_doctor(first_name, last_name, email, phone_1, phone_2, phone_3)
  FactoryGirl.create(:doctor, :first_name => first_name, :last_name => last_name, :email => email, :phone_1 => phone_1, :phone_2 => phone_2, :phone_3 => phone_3)
end

def add_admin(email, password)
  FactoryGirl.create(:admin, :email => email, :password => password)
end

Given /the following doctors exist/ do |doctors_table|
  doctors_table.hashes.each do |doctor|
    add_doctor(doctor['first_name'], doctor['last_name'], doctor['email'], doctor['phone_1'], doctor['phone_2'], doctor['phone_3'])
  end
end

Given /the following admins exist/ do |admins_table|
  admins_table.hashes.each do |admin|
    add_admin(admin['email'], admin['password'])
  end
end

Given /one default admin exists/ do
  add_admin('default@admin.com','password')
end

Given /I am logged as the default admin/ do

  visit '/users/login'
  fill_in 'user_email', :with => 'default@admin.com'
  fill_in 'user_password', :with => 'password'
  click_button 'Log in'
end

When /I delete "(.*)"/ do |doctor|
  id = Doctor.find_by_first_name(doctor).id
  click_on("delete_doctor_"+id.to_s)
  #page.driver.browser.accept_js_confirms
  #@javascript - this goes before the scenario
end

When /I change my mind to not delete "(.*)"/ do |doctor|
  id = Doctor.find_by_first_name(doctor).id
  click_on("delete_doctor_"+id.to_s)
  #handle_js_confirm(accept = false)
  #dialog = page.driver.browser.switch_to.alert
  #dialog.text.should == "Delete '#{@article.title}'?"
  #dialog.dismiss
  page.driver.browser.reject_js_confirms
end

When /I edit "(.*)" with "(.*)" as "(.*)"/ do |doctor, field, new_name|
  id = Doctor.find_by_last_name(doctor).id
  click_link("edit_doctor_"+id.to_s)
  fill_in field, :with => new_name
  click_button("Update Doctor")
  #find_by_id("edit_doctor_"+id.to_s).click_link
  #page.driver.browser.accept_js_confirms
  #@javascript - this goes before the scenario
end

Then /I click the "(.*)" button$/ do |button|
end
