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
  add_admin('default_admin@example.com','password')
end

Given /one default doctor exists/ do
  phone_number = '18001234567'
  add_doctor('default_doctor@example.com','password', 'default_doctor@example.com', phone_number, phone_number, phone_number)
end

Given /I am logged in as the default (.*)/ do |user_type|
  visit '/users/login'
  fill_in 'user_email', :with => "default_#{user_type}@example.com"
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

Given /there are (no )?pending shifts/ do |no_open_shifts|
  if no_open_shifts
    # There should be no pending shifts in the database.
    if Shift.count(confirmed: false) != 0
      raise 'Expected there to be no shifts but shifts are present.'
    end
  else
    # Add a shift to the database
    add_shift(DateTime.new(2015, 2, 14, 8, 00), DateTime.new(2015, 2, 14, 14, 30))
  end
end

Then /I should be able to sign up for a shift/ do
  page.should have_content("Current Shifts available")
  # I have no idea why I need to select the check box like this so if someone has
  # a better idea let me know
  find(:css, "#post_shifts_1").set(true) # Naively check the first checkbox.
  find(:css, "#post_shifts_1").should be_checked
  click_button("Sign up for these shifts")
end

Then /I should be unable to sign up for shifts/ do
  text = 'No shifts are currently available to sign up for.'
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then /I should receive confirmation that the request was successful/ do
  text = "You successfully signed up for your requested shifts!"
  page.should have_content(text)
end

When /I log in with email "(.*)" and password "(.*)"/ do |email, password|
  visit '/users/login'
  fill_in 'user_email', :with => email
  fill_in 'user_password', :with => password
  click_button 'Log in'
end

When /I sign up with email "(.*)" and password "(.*)"/ do |email, password|
  FactoryGirl.create(:doctor, email: email, password: password, first_name: nil, last_name: nil, phone_1: nil, phone_2: nil, phone_3: nil)
  visit '/users/login'
  fill_in 'user_email', :with => email
  fill_in 'user_password', :with => password
  click_button 'Log in'
end

private
def add_doctor(first_name, last_name, email, phone_1, phone_2, phone_3)
  FactoryGirl.create(:doctor, :first_name => first_name, :last_name => last_name, :email => email, :phone_1 => phone_1, :phone_2 => phone_2, :phone_3 => phone_3)
end

def add_admin(email, password)
  FactoryGirl.create(:admin, :email => email, :password => password)
end

def add_shift(start_time, end_time)
  FactoryGirl.create(:shift, start_datetime: start_time, end_datetime: end_time)
end
