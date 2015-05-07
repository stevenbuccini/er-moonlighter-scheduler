class Doctor < User
	has_many :shifts

  # NOTE: THIS ASSUMES MONTHS! IF YOU CHANGE THIS VALUE, YOU NEED
  # TO CHANGE THE CALL TO Date#advance IN THE is_delinquent? METHOD
  MAX_TIME_SINCE_LAST_SHIFT = 2

	@@NAME = "Doctor"
	def self.NAME; @@NAME; end

	def self.update_pay_period(id)
		Doctor.update_all({pay_period_id: id})
	end

  def is_delinquent?
    # If last_shift_completion_date is non-nil, then return true if the last_shift
    # completion date is occurred over MAX_TIME_SINCE_LAST_SHIFT time ago
    return (self.last_shift_completion_date.advance(months: MAX_TIME_SINCE_LAST_SHIFT) < Date.today) if self.last_shift_completion_date
  end
  def send_email(doctor, params)
    subject = params[:subject]['Subject']
    text = params[:body]['Email Body']
    UserMailer.custom_email(doctor, subject, text).deliver_now
  end
end
