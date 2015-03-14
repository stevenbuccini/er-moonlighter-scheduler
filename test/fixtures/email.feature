Feature: send mass email

As an Admin so that I can contact all doctors I can send an email to all the doctors

Background:

	When I fill in the following users:
		| first_name | last_name | email          | type   |
		| Bob        |  Marley   | bm@example.com | Doctor |
		| Frank      |  Sinatra  | fr@example.com | Doctor |
		| Phil       |  Collins  | pc@example.com | Admin  |


Scenario: no text has been added to the email

When I go to the create email page
And I select to email "Bob Marley"
And I enter "Mass Email" as the subject line
And I press "Send Email"
Then I should see the error "Message needs a text body"

Scenario: no subject has been added to the email

When I go to the create email page
And I select to email "Bob Marley"
And I enter "Mass Email" as the email body
And I press "Send Email"
Then I should see the error "Message needs a text body"

Scenario: Send an email

When I go to the create email page
And I select to email "Bob Marley"
And I enter "Mass Email" as the email body
And I press "Send Email"
Then I should see the flash message "Email sent to Bob Marley, Frank Sinatra"


