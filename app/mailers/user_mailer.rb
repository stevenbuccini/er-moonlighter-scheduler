class UserMailer < ApplicationMailer
	def mandrill_client
      @mandrill_client ||= Mandrill::API.new ENV["MANDRILL_APIKEY"]
  end
	def welcome_email(user)
		template_name = "welcome-email"
    template_content = []
    message = mail_message(user)
    mandrill_client.messages.send_template template_name, template_content, message
	end

	def urgent_email(user,pay_period)
		template_name = "urgent-shifts-still-need-to-be-filled"
    mail_with_pay_period(template_name, user, pay_period)
	end

	def new_pay_period_email(user,pay_period)
		template_name = "new-pay-period-available"
    mail_with_pay_period(template_name, user, pay_period)
	end
  
  private
  def mail_with_pay_period(template_name, user, pay_period)
    template_content = []
      message = mail_message(user) << { name: "pay_period_range", content: pay_period }
    mandrill_client.messages.send_template template_name, template_content, message
  end
  def mail_message(user)
    message = {
        to: [{email: user.email}],
        merge_vars: [
          {rcpt: user.email,
           vars: [
              { name: "first_name", content: user.first_name }
            ]
          }
        ]
      }
  end

end
