Feature: delete doctors

  As an admin
  So that I can manage a list of current doctors
  I want to be able to delete a doctor

Background: doctors in database

  Given the following doctors exist:
  |first_name  |last_name   |email                  |phone_1        |phone_2        |phone_3        |
  |Alex        |Triana      |at@example.com         |555-555-5555   |nil            |nil            |
  |Tayo        |Olukoya     |theboss@example.com    |123-456-7890   |122-222-2345   |554-446-6456   |

Scenario: delete doctor 
  Given I am an admin
  And I am on the doctor_list page
  When I follow “delete” for “Triana”
  Then I should see “Are you sure you want to delete Alex Triana?”
  When I follow “Yes, delete”
  Then I should be on the doctor_list page
  And I should not see “at@example.com.com”
  And I should see “You just deleted Alex Triana”
 
Scenario: delete doctor 
  Given I am an admin
  And I am on the doctor_list page
  When I follow “delete” for “Triana”
  Then I should see “Are you sure you want to delete Alex Triana?”
  When I follow “No, do not delete”
  Then I should be on the doctor_list page
  And I should see “at@example.com”
  And I should not see “You just deleted Alex Triana”

