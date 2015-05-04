class PayPeriod < ActiveRecord::Base
	has_many :admins
	has_many :shifts, :dependent => :destroy
	has_many :doctors, :through => :shifts

	#Validations
	validates_presence_of :start_date, :end_date
	validate :pay_range

	def to_s
    self.start_date.strftime("%b %e") + " - " +  self.end_date.strftime("%b %e")
  end

  def to_str
    self.start_date.strftime("%b %e") + " - " +  self.end_date.strftime("%b %e")
  end

	def self.create_next(pay_period_params)
		last = PayPeriod.last!
		pay_period_params[:start_date] = last.end_date
		pay_period_params[:end_date] = last.end_date + 14 # Pay periods are always 2 weeks long
		temp = PayPeriod.new(pay_period_params)
		# Create shifts for this pay period in our local database.
		#byebug
		Shift.create_shifts_for_pay_period(temp.start_date.to_datetime, temp.end_date.to_datetime, temp.id)
		return temp
	end

	private
	def pay_range
		errors[:base] << "End date cannot be less than start date" unless start_date and end_date and end_date >= start_date
	end

	def self.get_open
		PayPeriod.where(is_open: true)
	end
end
