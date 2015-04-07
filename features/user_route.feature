Feature: Routes for users

  As a user 
  So I can be routed to my appropriate controller
  I don't want an unauthorized user to visit my page

Background: admin, regular user and doctors exist in database
  Given one default admin exists

  Given a new user exists

  Given the following doctors exist:

  | first_name  | last_name | email                  | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@example.com         | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@example.com    | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@example.com  | 760-805-9889 | nil          | nil          |

Scenario: User awainting approval login happy path!
  Given I am signed in as a user awaiting admin approval
  And I update my profile page
  Then I should see user awaiting admin approval on my login page

Scenario: User awainting approval login sad path!
  Given I am signed in as a user awaiting admin approval
  Then I should see user awaiting admin approval on my login page

Scenario: Doctor Login happy path!
  Given I am an existing doctor
  When I sign in with my Login credentials
  Then I should be taking to the doctor's login page

Scenario: Doctor Login sad path!
  Given I am signed in as a doctor
  When I try to visit the admin homepage
  Then I should see "You are not authorised to view an Admin's page"

Scenario: Admin Login happy path!
  Given I am an existing admin
  When I sign in with my Login credentials
  Then I should be taking to the admin's login page

Scenario: Admin Login sad path!
  Given I am signed in as an admin
  When I try to visit the doctor's homepage
  Then I should see a notice You are not authorised to view Doctor's page