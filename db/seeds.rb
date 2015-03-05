# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

users = [{:first_name => 'Joe', :last_name => "Biden",:type => :doctor, :email => 'jbiden@example.com', :user_id => 123456},
    	  {:first_name => 'James', :last_name => "Brown",:type => :doctor, :email => 'jbrown@example.com', :user_id => 123465},
        {:first_name => 'Simon', :last_name => "Jones",:type => :doctor, :email => 'sjones@example.com', :user_id => 123564},
        {:first_name => 'James', :last_name => "Brown",:type => :doctor, :email => 'jbrown@example.com', :user_id => 124563},
        {:first_name => 'Sarah', :last_name => "Wilson",:type => :doctor, :email => 'swilson@example.com', :user_id => 134562},
        {:first_name => 'Anna', :last_name => "Hathaway",:type => :super_admin, :email => 'ahathway@example.com', :user_id => 234561},
        {:first_name => 'Mitchel', :last_name => "Nitche",:type => :doctor, :email => 'mnitche@example.com', :user_id => 123546},
        {:first_name => 'Leonard', :last_name => "Ralph",:type => :admin, :email => 'lralph@example.com', :user_id => 124356},
        {:first_name => 'Thomas', :last_name => "Jacob",:type => :admin, :email => 'tjacob@example.com', :user_id => 132456},
  
  
  	 ]

users.each do |user|
  User.create!(user)
end
