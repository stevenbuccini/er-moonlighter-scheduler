Feature: change root

  As a user
  So that I can edit my info immediately upon signup
  I want to be directed to my edit page on my first sign in only

Background: User exists
  Given one default admin exists


Scenario: Update Info for Doctor
  Given I have created an account
  When I sign in for the first time
  Then I should edit my info
  And then I should be on the doctor index page
  And I should see my first name, last name, and email