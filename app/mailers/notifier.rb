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
        custom_email(adm, subject, text)
      end
    end
  end
end
