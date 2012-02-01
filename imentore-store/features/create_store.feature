Feature: Create store
  In order to sell my products online
  As a soon-to-be customer
  I want to create my own store

  Scenario: Create store
    Given I am a visitor
    And I am on the form to create a new store
    When I fill in and submit the form
    Then I should see "Congrats!"