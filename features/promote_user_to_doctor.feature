Feature: Approve new Doctors

  As an admin
  So that I can approve any valid doctor awaiting approval
  I want to be able to promote a user to a doctor

Background: admin, a user awaiting approval and doctors exist in database

  Given one default admin exists

  Given a new user signup with name James Jones

  Given the following doctors exist:

  | first_name  | last_name | email                  | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@example.com         | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@example.com    | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@example.com  | 760-805-9889 | nil          | nil          |

Scenario: Promote user to doctor
  Given I am logged in as the default admin
  When I approve Jame Jones to become a doctor
  Then I should see Jame Jones in the table of doctors
  
