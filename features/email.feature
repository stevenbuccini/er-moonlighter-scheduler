Feature: send mass email

  As an admin
  So that I can contact all current doctors
  I want to send a custom email to all doctors

Background: admin existing and doctors in database
  Given one default admin exists
  Given the following doctors exist:

  | first_name  | last_name | email               | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@b.edu            | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@me.com      | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@gmail.com | 760-805-9889 | nil          | nil          |

  And I am logged as the default admin

Scenario: View all doctors after logging in
  And I am on the create email page
  And I fill in "Mass email" as the "subject"
  And I fill in "This is a mass email" as the "body"
  And I click "Send Email"
  Then I should see "Email sent to: Alex Triana Tayo Olukoya Kristina Sep"
