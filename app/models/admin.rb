class Admin < User
	@@NAME = "Admin"
	belongs_to :pay_period

  # We only want to read this field, should never be able to update it for admins
  # The only reason this exists is because we're leveraging STI even though we've
  # grown out of it at this point.

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
        UserMailer.urgent_email(doctor,params[:pay_period]).deliver_now
      when 'new_pay_period'
        UserMailer.new_pay_period_email(doctor,params[:pay_period]).deliver_now
      else
        subject = params[:subject]['Subject']
        text = params[:body]['Email Body']
        UserMailer.custom_email(doctor, subject, text).deliver_now
    end
	end
	def self.update_pay_period(id)
		Admin.all.each do |adm|
			adm.update_attribute(:pay_period_id, id)
		end
	end

  # We only want to read this field, should never be able to update it for admins
  # The only reason this exists is because we're leveraging STI even though we've
  # grown out of it at this point. Always return nil here.
  def last_shift_completion_date
    return nil
  end

  # We need to define this method here, or else it will hoist up to the User class
  # where this method is defined. We throw an exception here so any unsuspecting programmer
  # attempting to use this method will enconter this error in testing and come here.
  # Remember -- This construction doesn't make sense for Admins. The only reason it's even
  # available to admins is because we're using STI, which we're hoping to refactor soon.
  def last_shift_completion_date=
    raise Exception
  end
end
