Feature: Approve new Doctors

  As an admin
  So that I can approve any valid doctor awaiting approval
  I want to be able to promote a user to a doctor

Background: admin, a user awaiting approval and doctors exist in database

  Given one default admin exists

  Given a new user signup with name jame jones

  Given the following doctors exist:

  | first_name  | last_name | email               | phone_1      | phone_2      | phone_3      |
  | Alex        | Triana    | at@b.edu            | 555-555-5555 | nil          | nil          |
  | Tayo        | Olukoya   | theboss@me.com      | 123-456-7890 | 122-222-2345 | 554-446-6456 |
  | Kristina    | Sep       | supercool@gmail.com | 760-805-9889 | nil          | nil          |

Scenario: Promote user to doctor
  

