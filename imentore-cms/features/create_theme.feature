Feature: Create a new theme

  Background:
    Given there is a store MyShop
    And I am logged in as the MyShop's owner

  Scenario: Create theme
    When I go to the new theme page
    And create a theme called "Ocean"
    Then I should see Ocean's details page