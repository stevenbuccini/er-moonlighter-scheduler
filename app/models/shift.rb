class Shift < ActiveRecord::Base
	has_many :doctors

	def to_s
		self.start.strftime("%b %e, %l:%M %p") + " - " +  self.start.strftime("%b %e, %l:%M %p")
	end
end

