Feature: Signup
	As a potential user interested in signing up for an acount on er-moonligher.herokuapp.com
	I want to sign-up as a new user
	So that I can have access to features on the app after admin approval

	Background: admin, a user awaiting approval and doctors exist in database

	Given one default admin exists

  Given a new user signup with name James Jones

  Given the following doctors exist:

  | first_name  | last_name | email                  | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@example.com         | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@example.com    | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@example.com  | 760-805-9889 | nil          | nil          |


 Scenario: Sign up
 	Given I am on er-moonligher.herokuapp.com signing page 
 	When I sign up with username "jlegend@example.com" and password 111111111
 	Then I should be on the edit page



