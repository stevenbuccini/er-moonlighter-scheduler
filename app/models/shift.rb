class Shift < ActiveRecord::Base
	has_many :doctors

	def to_s
		self.start.strftime("%b %e, %I:%M%p") + " - " +  self.start.strftime("%b %e, %I:%M%p")
	end
end

