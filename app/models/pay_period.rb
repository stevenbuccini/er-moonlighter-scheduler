class PayPeriod < ActiveRecord::Base
	has_many :admins
	has_many :shifts, :dependent => :destroy
	has_many :doctors, :through => :shifts

	#Validations
	validates_presence_of :start_date, :end_date
	validate :pay_range

	def self.create_next(open)
		last = PayPeriod.last!
		return PayPeriod.new({:start_date => last.end_date, :end_date => last.end_date + 14, :is_open => open})
	end

	private
	def pay_range
		errors[:base] << "End date cannot be less than start date" unless start_date and end_date and end_date >= start_date
	end

	def self.get_open
		PayPeriod.where(is_open: true)
	end
end
