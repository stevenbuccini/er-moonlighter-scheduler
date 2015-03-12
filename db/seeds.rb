# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [{:first_name => 'Joe', :last_name => "Biden",:type => "Doctor", :email => 'jbiden@example.com', :phone_1 => '012-345-6789', :phone_2 => '333-333-3333', :phone_3 => '444-444-4444', :user_id => 123456, :password => 11111111},
    	  {:first_name => 'James', :last_name => "Brown",:type => "Doctor", :email => 'jbrown@example.com', :phone_1 => '223-232-2323', :phone_2 => '567-567-5675', :user_id => 123465, :password => 11111111},
        {:first_name => 'Simon', :last_name => "Jones",:type => "Doctor", :email => 'sjones@example.com', :phone_1 => '777-777-7777', :user_id => 123564, :password => 11111111},
        {:first_name => 'James', :last_name => "Brown",:type => "Doctor", :email => 'jbrown2@example.com', :phone_1 => '223-232-2323', :phone_2 => '567-567-5675', :user_id => 123564, :password => 11111111},
        {:first_name => 'Sarah', :last_name => "Wilson",:type => "Doctor", :email => 'swilson@example.com', :phone_1 => '563-345-2345', :phone_2 => '666-666-6666', :phone_3 => '888-888-8888', :user_id =>111111, :password => 11111111},
        {:first_name => 'Anna', :last_name => "Hathaway",:type => "Admin", :email => 'ahathway@example.com', :phone_1 => '234-645-7867', :user_id => 112321, :password => 11111111},
        {:first_name => 'Mitchel', :last_name => "Nitche",:type => "Doctor", :email => 'mnitche@example.com', :phone_1 => '760-805-9889', :phone_2 => '456-456-4564', :user_id => 128546, :password => 11111111},
        {:first_name => 'Leonard', :last_name => "Ralph",:type => "Admin", :email => 'lralph@example.com', :phone_1 => '887-546-4575', :user_id => 456789, :password => 11111111},
        {:first_name => 'Thomas', :last_name => "Jacob",:type => "Admin", :email => 'tjacob@example.com', :phone_1 => '999-998-8787', :user_id => 345672, :password => 11111111},
        {:first_name => 'Britney', :last_name => "Spears", :type => "User", :email => 'bspears@example.com', :phone_1 => '237-765-9999', :password => 11111111},
        {:first_name => 'Rihanna', :last_name => "Brown", :type => "User", :email => 'missbrown@example.com', :phone_1 => '567-897-8670', :password => 11111111},
        {:first_name => 'Kate', :last_name => "Hudson", :type => "User", :email => 'khudson555@example.com', :phone_1 => '555-678-3467', :password => 11111111}

     ]

users.each do |user|
  User.create!(user)
end
