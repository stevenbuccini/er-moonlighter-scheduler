class Shift < ActiveRecord::Base
	belongs_to :doctor

	def after_initialize
		# This method gets called as a callback to any method that creates
		# an instance of this model, including find() !

		# Set this default value if we are creating a new record 
		if new_record?
			self.confirmed = false 
			# We should definitely have start and end times whenever we create a shift
			if !self.start || !self.end
				raise ArgumentError, ' start and end times are required when creating a shift.'
			end
		end
		# Check to make sure start date occurs before end date
		if self.start < self.end
				raise ArgumentError, ' start time must come before end time.'
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
end

