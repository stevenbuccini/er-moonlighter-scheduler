class Admin < User
	@@NAME = "Admin"
	def self.NAME; @@NAME; end

	def self.get_doctor_names(doctors)
		names = ""
		doctors.each do |doctor|	
			names = names + doctor.full_name + " "
		end
		names
	end
end
