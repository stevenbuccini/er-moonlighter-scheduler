class Shift < ActiveRecord::Base
	has_many :doctors

	def to_s
		self.strftime("%b %e, %I:%M%p - %b %e, %I:%M%p")
	end
end

