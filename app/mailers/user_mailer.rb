class UserMailer < ApplicationMailer
	default from: 'er.moonlighter.scheduler.com'

	def dummy_email(doctor, subject, text)
		@user = doctor
		@text = text
		mail(to: @user.email, subject: subject)
	end

	def welcome_email(user)
		@user = user
		mail(to: @user.email, subject: 'Welcome to My Awesome Site')
	end

end
