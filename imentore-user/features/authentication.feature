Feature: Login
  As a visitor
  I want to login with my email and password
  So I can access my personal stuff

  Background:
    Given there is a store named MyShop
    And I am a visitor

  Scenario: Owner login
    When I go to the admin login page
    And login with the owner account
    Then I should see the MyShop's dashboard