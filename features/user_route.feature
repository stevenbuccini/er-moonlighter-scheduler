Feature: Routes for users

  As a user 
  So I can be routed to my appropriate controller
  I don't want an unauthorized user to visit my page

Background: admin, regular user and doctors exist in database
  Given one default admin exists
  Given one default doctor exists

  Given a new user exists

  Given the following doctors exist:

  | first_name  | last_name | email                  | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@example.com         | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@example.com    | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@example.com  | 760-805-9889 | nil          | nil          |

Scenario: User awaiting approval login happy path!
  Given I am signed in as a user awaiting admin approval
  Then I should see "Your account is awaiting admin's approval" 

Scenario: User awainting approval login sad path!
  Given I am signed in as a user awaiting admin approval
  Then I should not see "Contact List"

Scenario: Doctor Login happy path!
  Given I am logged in as the default doctor
  Then I should be on the doctor's index

Scenario: Doctor Login sad path!
  Given I am logged in as the default doctor
  When I visit admins
  Then I should see "You are not authorised to visit this page"

Scenario: Admin Login happy path!
  Given I am logged in as the default admin
  Then I should be on the admin index

Scenario: Admin Login sad path!
  Given I am logged in as the default admin
  When I visit doctors
  Then I should see "You are not authorised to visit this page"