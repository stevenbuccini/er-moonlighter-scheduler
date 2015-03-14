Feature: update doctor

  As an admin
  So that I can manage a list of current doctors
  I want to be able to update a doctor’s info

Background: doctors in database

  Given the following doctors exist:
  |first_name   |last_name  |email                  |phone_1        |phone_2        |phone_3        |
  |Alex         |Triana     |at@example.edu         |555-555-5555   |nil            |nil            |
  |Tayo         |Olukoya    |theboss@example.com    |123-456-7890   |122-222-2345   |554-446-6456   |
  |Kristina     |Sep        |supercool@example.com  |760-805-9889   |nil            |nil            |

Scenario: update doctor
  Given I am an admin
  And I am on the doctor_list page
  When I follow “edit” for “Sep”
  Then I should be on the edit_doctor page

Scenario: update a doctor (happy path)
  Given I am on the edit_doctor page
  And I see “first name” with “Kristina”
  And I see “last name” with “Sep”
  And I see “email” with “supercool@example.com”
  And I see “phone_1” with “760-805-9889”
  And I fill in “notsupercool@example.com”
  When I follow “submit_changes”
  Then I should be on the doctor_list page
  And I should see “notsupercool@example.com”
  And I should not see “supercool@example.com”
  And I should see “Sep has been updated”

Scenario: update a doctor (sad path)
  Given I am on the edit_doctor page for “supercool@example.com”
  And I see “first name” with “Kristina”
  And I see “last name” with “Sep”
  And I see “email” with “supercool@example.com”
  And I see “phone_1” with “760-805-9889”
  When I fill in “email” with “”
  When I follow “submit_changes”
  Then I should be on the edit_doctor page for “supercool@example”
  And I should see “No email is filled in”
