class Shift < ActiveRecord::Base
	belongs_to :doctor

	after_initialize :init

	validates_presence_of :start_datetime, :end_datetime
	validate :start_datetime_must_be_before_end_datetime


	def init
		# This method gets called as a callback to any method that creates
		# an instance of this model, including find() !

		if new_record?
			self.confirmed = false 
		end
	end

	def to_s
		self.start.strftime("%b %e, %l:%M %p") + " - " +  self.start.strftime("%b %e, %l:%M %p")
	end

	def to_str
		self.start.strftime("%b %e, %l:%M %p") + " - " +  self.start.strftime("%b %e, %l:%M %p")
	end

	def book(current_user)
		self.confirmed = true
		self.doctor = current_user
	end

	def start_datetime_must_be_before_end_datetime
		errors.add(:end_datetime, "can't be before the start time") if start_datetime > end_datetime
	end
end

