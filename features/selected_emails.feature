Feature: send emails to selected doctors

  As an admin
  So that I can send emails to some doctors I choose
  I want be able to select doctors and send them emails

Background: admin existing and doctors in database
  Given one default admin exists

  Given the following doctors exist:

  | first_name  | last_name | email               | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@b.edu            | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@me.com      | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@gmail.com | 760-805-9889 | nil          | nil          |

  Scenario: send email to some doctors (happy path)

  Given I am logged in as the default admin
  And I am on the admin index
  When I select "Alex Triana"
  And I select "Tayo Olukoya"
  And I press "Send Selected Email"
  Then the email should not be sent to "Kristina Sep"
  And the email should be sent to "Alex Triana"
  And the email should be sent to "Tayo Olukoya"

  Scenario: send email to some doctors (sad path: no doctors selected)

  Given I am logged in as the default admin
  And I am on the admin index
  And I press "Send Selected Email"
  Then I should see "Please select doctors you want to send emails to"
  And the email should not be sent to "Kristina Sep"