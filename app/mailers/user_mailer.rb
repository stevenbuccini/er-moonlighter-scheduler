class UserMailer < ApplicationMailer
	default from: 'er.moonlighter.scheduler.com'

	def mandrill_client
      @mandrill_client ||= Mandrill::API.new ENV["MANDRILL_APIKEY"]
    end

	def custom_email(doctor, subject, text)
		@user = doctor

		template_name = "custom-template"
      template_content = []
      message = {
        to: [{email: @user.email}],
        merge_vars: [
          {rcpt: @user.email,
           vars: [
              { name: "first_name", content: @user.first_name },
              {name: "subject", content: subject},
              {name: "body", content: text}
            ]
          }
        ]
      }
    mandrill_client.messages.send_template template_name, template_content, message 
	end

	def welcome_email(user)
		template_name = "welcome-email"
      template_content = []
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
    mandrill_client.messages.send_template template_name, template_content, message 
	end

	def urgent_email(user)
		template_name = "urgent-shifts-still-need-to-be-filled"
      template_content = []
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
    mandrill_client.messages.send_template template_name, template_content, message 
	end

	def new_pay_period_email(user)
		template_name = "new-pay-period-available"
      template_content = []
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
    mandrill_client.messages.send_template template_name, template_content, message 
	end

end
