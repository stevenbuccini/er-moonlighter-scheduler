Feature: doctors should be able select shifts

  As an doctor
  So I that I can sign up for shifts after the initial assignment of the calendar
  I should to be able to sign up for any available shift that I want
  And I should automatically receive confirmation that it is mine.

  Background: 
    Given there are pending shifts
    And given one default doctor exists

	Scenario: Sign up for an open shift
	  Given I am logged in as the default doctor
	  And I am on the doctor index
	  Then I should be able to sign up for a shift
	  And I should receive confirmation that it's pending admin approval.
