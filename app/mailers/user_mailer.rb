class UserMailer < ApplicationMailer
	default from: 'er.moonlighter.scheduler.com'

	def send_dummy_emails(doctors)
		doctors.each do |doctor|
			dummy_email(doctor)
		end

	end

	def dummy_email(doctor)
		@user = doctor
		mail(to: @user.email, subject: "This is a mass email", text: "Foo bar")
	end

	

	def welcome_email(user)
		@user = user
		@url = 'localhost:3000/login'
		mail(to: @user.email, subject: 'Welcome to My Awesome Site')
	end
end
