class Admin < User
	@@NAME = "Admin"
	belongs_to :pay_period
	def self.NAME; @@NAME; end

	def self.get_doctor_names(doctors)
		names = ""
		doctors.each do |doctor|	
			names = names + doctor.full_name + " "
		end
		names
	end
	def self.update_pay_period(id)
		Admin.all.each do |adm|
			adm.update_attribute(:pay_period_id, id)
		end
	end
end
