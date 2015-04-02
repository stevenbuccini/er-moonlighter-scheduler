class UserMailer < ApplicationMailer
	default from: 'er.moonlighter.scheduler.com'

	def mandrill_client
      @mandrill_client ||= Mandrill::API.new ENV["MANDRILL_APIKEY"]
    end

	def dummy_email(doctor, subject, text)
		@user = doctor
		@text = text
		mail(to: @user.email, subject: subject)
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

end
