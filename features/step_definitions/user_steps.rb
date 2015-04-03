def add_doctor(first_name, last_name, email, phone_1, phone_2, phone_3)
  FactoryGirl.create(:doctor, :first_name => first_name, :last_name => last_name, :email => email, :phone_1 => phone_1, :phone_2 => phone_2, :phone_3 => phone_3)
end

def add_admin(email, password)
  FactoryGirl.create(:admin, :email => email, :password => password)
end
def add_unauthorised_user(email, password)
  FactoryGirl.create(:user, :email => email, :password => password)
end
Given /an unauthorised user exists/ do 
  add_unauthorised_user('unauthorised@example.com','password')
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
Given(/^I am signed in as a user awaiting admin approval$/) do
  visit '/users/login'
  fill_in 'user_email', :with => 'unauthorised@example.com'
  fill_in 'user_password', :with => 'password'
  click_button 'Log in'
end
Given(/^I update my profile page$/) do
  pending # express the regexp above with the code you wish you had
end

Given /I am logged as the default admin/ do
  visit '/users/login'
  fill_in 'user_email', :with => 'default@admin.com'
  fill_in 'user_password', :with => 'password'
  click_button 'Log in'
end

