Feature: update doctor

  As an admin
  So that I can manage a list of current doctors
  I want to be able to update a doctor’s info

Background: doctors in database
  Given one default admin exists

  Given the following doctors exist:
  |first_name   |last_name  |email                  |phone_1        |phone_2        |phone_3        |
  |Alex         |Triana     |at@example.edu         |555-555-5555   |nil            |nil            |
  |Tayo         |Olukoya    |theboss@example.com    |123-456-7890   |122-222-2345   |554-446-6456   |
  |Kristina     |Sep        |supercool@example.com  |760-805-9889   |nil            |nil            |


Scenario: update doctor (happy path)
  Given I am logged as the default admin
  Given I am on the admin index
  When I edit "Sep" with "Last name" as "Flowers"
  Given I am on the admin index
  Then I should see "Flowers"
  Then I should not see "Sep"



