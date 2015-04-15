Feature: change root

  As a user
  So that I can edit my info immediately upon signup
  I want to be directed to my edit page on my first sign in only

Background: User exists
  Given one default admin exists

  Given the following doctors exist:
  |first_name  |last_name   |email                  |phone_1        |phone_2        |phone_3       |
  |Kristina    |Sep         |sep@example.com        |111-111-1111   |               |              |

Scenario: Complete registration login
  When I log in with email "sep@example.com" and password "password"
  Then I should see "Current Shifts available"

Scenario: Complete registration login
  When I sign up with email "tester@example.com" and password "password"
  Then I should see "Edit User"