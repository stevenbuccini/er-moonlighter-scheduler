Feature: see list of doctors

  As an admin
  So that I can manage a list of current doctors
  I want to see all current doctors

Background: admin existing and doctors in database
  Given one default admin exists

  Given the following doctors exist:

  | first_name  | last_name | email               | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@b.edu            | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@me.com      | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@gmail.com | 760-805-9889 | nil          | nil          |

Scenario: View all doctors after logging in
  Given I am logged as the default admin
  And I am on the admin index
  Then I should see "at@b.edu"
  And I should see "theboss@me.com"
  And I should see "supercool@gmail.com"
