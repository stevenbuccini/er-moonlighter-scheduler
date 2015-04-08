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
		self.start_datetime.strftime("%b %e,%l:%M %p") + " - " +  self.end_datetime.strftime("%b %e,%l:%M %p")
	end

	def to_str
		self.start_datetime.strftime("%b %e,%l:%M %p") + " - " +  self.end_datetime.strftime("%b %e,%l:%M %p")
	end

	def book(current_user)
		self.confirmed = true
		self.doctor = current_user
	end

	def start_datetime_must_be_before_end_datetime
		# Check for non-nil since the ">" operator is not defined for these functions.
		if start_datetime and end_datetime
			errors.add(:sanity_check, "end time can't be before the start time") if start_datetime > end_datetime
		end
	end
end

