class Shift < ActiveRecord::Base
	belongs_to :doctor

	def init
		self.confirmed = false
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

