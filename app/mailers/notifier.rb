class Notifier < ApplicationMailer
	def mandrill_client
      @mandrill_client ||= Mandrill::API.new ENV["MANDRILL_APIKEY"]
  end

  #This method sends the email to do recipient and notify an admin assistant
	def notify(doctor ,recipient, subject, text)
    subject += " sent to: #{recipient}, by: #{doctor.full_name}" 
		admin_assists = AdminAssistant.all 
    if admin_assists
      admin_assists.each do |adm|
        notify_admin_assist(adm, subject, text)
      end
    end
  end
  def notify_admin_assist(admin_assist, subject, text)
    @user = admin_assist
    template_name = "custom-template"
      template_content = []
      message = {
        to: [{email: @user.email,  type: "bcc"}],
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
