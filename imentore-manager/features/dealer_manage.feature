Feature: Manage Dealer

  Background:
  Given there in the land Deal page
    #And I am logged in as the owner

  Scenario: Create new Dealer with Talent
    Given I could access dashboard
    And I can created dealer with talent
    Then I should see talent created

  Scenario: Login Admin Dealer Dashboard
    Given I am the login page
    And I fill form login
    Then I am access admin dealer dashbord

