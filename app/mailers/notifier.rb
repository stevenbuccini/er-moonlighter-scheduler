class Notifier < ApplicationMailer
	def mandrill_client
      @mandrill_client ||= Mandrill::API.new ENV["MANDRILL_APIKEY"]
  end
	def notify(doctor, subject, text)
    # @account = recipient
    # mail(to: recipient.email_address_with_name,
    #      bcc: ["bcc@example.com", "Order Watcher <watcher@example.com>"])
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
