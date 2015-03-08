class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :first_name, :last_name, :email

  def new
    # Manually set the type to Doctor.
    # Every account signed up through Devise starts out as a Doctor,
    # and must be manually promoted to an Admin by a current admin.
    self.type = :doctor
    super
  end
end
