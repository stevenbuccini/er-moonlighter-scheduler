class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

 # attr_accessor :first_name, :last_name
 # do not uncomment the above line, or else first_name and last_name will not be saved in the database 

  def full_name
   	if self.first_name != nil and self.last_name != nil
   		self.first_name + " " + self.last_name
   	else
   		"User does not have a full name"
   	end
  end

  def registration_complete
    required = [ 'first_name', 'last_name', 'phone_1', 'email' ]
    required.each do |field|
      if self.send(field) == nil
        self.registration_done = false
        return false
      end
    end
    self.registration_done = true
    return true
  end

end
