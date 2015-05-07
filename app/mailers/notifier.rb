class Notifier < ApplicationMailer
	def mandrill_client
      @mandrill_client ||= Mandrill::API.new ENV["MANDRILL_APIKEY"]
  end

  #This method sends the email to do recipient and notify an admin assistant
	def notify(doctor, subject, text)
    @user = doctor
		template_name = "custom-template"
      template_content = []
      message = {
      	bcc_address:  "ermoonlighter@gmail.com",
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
