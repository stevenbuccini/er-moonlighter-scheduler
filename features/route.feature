Feature: Routes for users

  As a user 
  So I can be routed to my appropriate controller
  I donot want unauthorized user to visit my dashboard

Background: admin, regular user and doctors exist in database
  Given one default admin exists

  Given an unauthorised user exists

  Given the following doctors exist:

  | first_name  | last_name | email               | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@b.edu            | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@me.com      | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@gmail.com | 760-805-9889 | nil          | nil          |

Scenario: Unapprove user login
  Given I am signed in as a user awaiting admin approval
  And I update my profile page
  Then I should see user awaiting admin approval on my login page

