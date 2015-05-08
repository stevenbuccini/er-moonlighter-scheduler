class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
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
end
