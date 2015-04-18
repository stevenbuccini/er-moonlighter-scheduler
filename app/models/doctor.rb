class Doctor < User
	has_many :shifts
	@@NAME = "Doctor"
	def self.NAME; @@NAME; end

	def self.update_pay_period(id)
		Doctor.all.each do |doc|
			doc.update_attribute(:pay_period_id, id)
		end
	end
end
