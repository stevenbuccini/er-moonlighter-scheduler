class UserMailer < ApplicationMailer
	default from: 'er.moonlighter.scheduler.com'

	def custom_email(doctor, subject, text)
		@user = doctor
		@text = text
		if @user.email
			mail(to: @user.email, subject: subject)
		end
	end

	def welcome_email(user)
		@user = user
		if @user.email
			mail(to: @user.email, subject: 'Welcome to My Awesome Site')
		end
	end

end
