class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 # attr_accessor :first_name, :last_name
 # do not uncomment the above line, or else first_name and last_name will not be saved in the database 

end
