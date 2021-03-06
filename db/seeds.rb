# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'date'

users = [{:first_name => 'Joe', :last_name => "Biden",:type => "Doctor", :email => 'jbiden@example.com', :phone_1 => '012-345-6789', :phone_2 => '333-333-3333', :phone_3 => '444-444-4444', :password => 11111111, :comments => "I prefer weekends"},
    	  {:first_name => 'James', :last_name => "Brown",:type => "Doctor", :email => 'jbrown@example.com', :phone_1 => '223-232-2323', :phone_2 => '567-567-5675', :password => 11111111, :comments => "I can work evenings a lot easier than morning"},
        {:first_name => 'Simon', :last_name => "Jones",:type => "Doctor", :email => 'sjones@example.com', :phone_1 => '777-777-7777', :password => 11111111, :comments => "I can work anytime!"},
        {:first_name => 'James', :last_name => "Brown",:type => "Doctor", :email => 'jbrown2@example.com', :phone_1 => '223-232-2323', :phone_2 => '567-567-5675', :password => 11111111},
        {:first_name => 'Sarah', :last_name => "Wilson",:type => "Doctor", :email => 'swilson@example.com', :phone_1 => '563-345-2345', :phone_2 => '666-666-6666', :phone_3 => '888-888-8888', :password => 11111111},
        {:first_name => 'Anna', :last_name => "Hathaway",:type => "Admin", :email => 'ahathway@example.com', :phone_1 => '234-645-7867', :password => 11111111},
        {:first_name => 'Mitchel', :last_name => "Nitche",:type => "Doctor", :email => 'mnitche@example.com', :phone_1 => '760-805-9889', :phone_2 => '456-456-4564', :password => 11111111},
        {:first_name => 'Leonard', :last_name => "Ralph",:type => "Admin", :email => 'lralph@example.com', :phone_1 => '887-546-4575', :password => 11111111},
        {:first_name => 'Thomas', :last_name => "Jacob",:type => "Admin", :email => 'tjacob@example.com', :phone_1 => '999-998-8787', :password => 11111111},
        
        {:first_name => 'Mark', :last_name => "Twain",:type => "AdminAssistant", :email => 'mtwain@example.com', :phone_1 => '887-546-4575', :password => 11111111},
        {:first_name => 'Sarah', :last_name => "Peet",:type => "AdminAssistant", :email => 'speet@example.com', :phone_1 => '999-998-8787', :password => 11111111},

        {:first_name => 'Britney', :last_name => "Spears", :type => "User", :email => 'bspears@example.com', :phone_1 => '237-765-9999', :password => 11111111},
        {:first_name => 'Rihanna', :last_name => "Brown", :type => "User", :email => 'missbrown@example.com', :phone_1 => '567-897-8670', :password => 11111111},
        {:first_name => 'Kate', :last_name => "Hudson", :type => "User", :email => 'khudson555@example.com', :phone_1 => '555-678-3467', :password => 11111111},
        {:type => "User", :email => 'reg_test@example.com', :password => 11111111}, 
        {:type => "User", :email => 'reg_test2@example.com', :password => 11111111},
        {:type => "User", :email => 'reg_test3@example.com', :password => 11111111},
        {:type => "Admin", :email => 'admin@example.com', :password => 11111111}, 
        {:type => "Doctor", :email => 'doctor@example.com', :password => 11111111},
        {:type => nil, :email => 'user@example.com', :password => 11111111}

  	 ]

users.each do |user|
  User.create!(user)
end

pay_periods = [
  {start_date: DateTime.new(2015, 1, 14), end_date: DateTime.new(2015, 1, 25), is_open: true, phase: 1},
  {start_date: DateTime.new(2015, 2, 25), end_date: DateTime.new(2015, 3, 8), is_open: true, phase: 1}
]

pay_periods.each do |p|
  PayPeriod.create!(p)
end


shifts = [
  {start_datetime: DateTime.new(2015, 2, 14, 8, 00), end_datetime: DateTime.new(2015, 2, 14, 14, 30), confirmed: true, pay_period_id: 1},
  {start_datetime: DateTime.new(2015, 2, 14, 4, 00), end_datetime: DateTime.new(2015, 2, 14, 12, 30), confirmed: false, candidates:[1,2,3], pay_period_id: 1},
  {start_datetime: DateTime.new(2015, 6, 28, 20, 00), end_datetime: DateTime.new(2015, 6, 29, 8, 30), confirmed: false, pay_period_id: 2},
  {start_datetime: DateTime.new(2015, 7, 6, 5, 43), end_datetime: DateTime.new(2015, 7, 6, 12, 30), pay_period_id:4},
  {start_datetime: DateTime.new(2015, 3, 14, 12, 14), end_datetime: DateTime.new(2015, 3, 14, 14, 30), pay_period_id: 2},
  {start_datetime: DateTime.new(2015, 5, 3, 2, 50), end_datetime: DateTime.new(2015, 6, 2, 15, 30), pay_period_id: 2}
]

shifts.each do |shift|
  Shift.create!(shift)
end


