Feature: Login
  As a visitor
  I want to login with my email and password
  So I can access my personal stuff

  Background:
    Given there is a store MyShop
    And I am a visitor

  Scenario: Owner login
    When I log in as MyShop's owner
    Then I should see the MyShop's dashboard