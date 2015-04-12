class PayPeriod < ActiveRecord::Base
	has_many :shifts, :dependent => :destroy
	has_many :doctors, :through => :shifts

	#Validations
	validates_presence_of :start_date, :end_date
	validate :start_date, presence: true 
	validate :end_date, presence:true 
	validate :pay_range


	def pay_range
		errors.add_to_base("End date cannot be less than start date") unless end_date >= start_date	
	end
end
