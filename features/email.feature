Feature: send mass email

As an Admin so that I can contact all doctors I can send an email to all the doctors

Background:

	Given the following doctors exist:
		| first_name | last_name | email          | phone1		 | phone2 | phone3 |
		| Bob        |  Marley   | bm@example.com | 111-111-1111 |    	  |        |
		| Frank      |  Sinatra  | fr@example.com | 222-222-2222 |		  |		   |
		| Phil       |  Collins  | pc@example.com | 333-333-3333 |		  |		   |
	And I one default admin exists
	And I am logged as the default admin


Scenario: select all doctors

When I am on the send email page
And I enter "Mass Email" as the "subject"
And I enter "This is a mass email" as the "body"
And I press "Send Email"
Then I should see "Email sent to: "
And I should see "Bob Marley"
And I should see "Frank Sinatra"
And I should see "Phil Collins"
