Feature: delete doctors

  As an admin
  So that I can manage a list of current doctors
  I want to be able to delete a doctor

Background: doctors in database
  Given one default admin exists

  Given the following doctors exist:
  |first_name  |last_name   |email                  |phone_1        |phone_2        |phone_3        |
  |Alex        |Triana      |at@example.com         |555-555-5555   |nil            |nil            |
  |Tayo        |Olukoya     |theboss@example.com    |123-456-7890   |122-222-2345   |554-446-6456   |



Scenario: delete doctor (happy path)
  Given I am logged in as the default admin
  And I am on the admin index
  When I delete "Alex"
  Then I should see "Doctor was successfully destroyed."
  Given I am on the admin index
  Then I should not see "at@example.com"

