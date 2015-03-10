Feature: send mass email

As an Admin so that I can contact all doctors I can send an email to all the doctors

Background:

	Given the following users exist:
		| first_name | last_name | email          |
		| Bob        |  Marley   | bm@example.com | 
		| Frank      |  Sinatra  | fr@example.com |
		| Phil       |  Collins  | pc@example.com |

Scenario: add doctor to email list

When I go to the send email page
And I select to email "Bob Marley"
And I enter "Mass Email" as the "Subject Line"
And I enter "This is a mass email" as the "Text"
And I press "Send Email"
Then the email should be sent to "Bob Marley"

Scenario: no doctor have been added to email list

When I go to the send email page
And I enter "Mass Email" as the "Subject Line"
And I enter "This is a mass email" as the "Text"
And I press "Send Email"
Then I should see the error "Message needs recipients"

Scenario: no text has been added to the email

When I go to the send email page
And I select to email "Bob Marley"
And I enter "Mass Email" as the "Subject Line"
And I press "Send Email"
Then I should see the error "Message needs a text body"

Scenario: a doctor is not on the email list

When I go to the send email page
And I do not select to email "Bob Marley"
And I enter "Mass Email" as the "Subject Line"
And I enter "This is a mass email" as the "Text"
And I press "Send Email"
Then the email should not be sent to "Bob Marley"

Scenario: select all doctors

When I go to the send email page
And I do not select to email "Email All Doctors"
And I enter "Mass Email" as the "Subject Line"
And I enter "This is a mass email" as the "Text"
And I press "Send Email"
Then the email should not be sent to "Bob Marley"
And the email should be sent to "Frank Sinatra"
And the email should be sent to "Phil Collins"
