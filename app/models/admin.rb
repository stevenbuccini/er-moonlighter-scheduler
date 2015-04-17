class Admin < User
	@@NAME = "Admin"
	def self.NAME; @@NAME; end

	def self.get_doctor_names(doctors)
		names = ""
		doctors.each do |doctor|	
			names = names + doctor.full_name + " and " 
		end
		names[0..-6]
	end

	def send_email(doctor, params)
		case params[:email_type]
      when 'urgent'
        UserMailer.urgent_email(doctor).deliver_now
      when 'new_pay_period'
        UserMailer.new_pay_period_email(doctor).deliver_now
      else
        subject = params[:subject]
        text = params[:body]
        UserMailer.custom_email(doctor, subject, text).deliver_now
    end
	end
end
