Feature: Manage Assets

  Background:
    Given there is a store
    And I am logged in as the owner


  Scenario: Create Assets
    Given I am at the green theme detalis page
    When I create new asset
    Then I see it in the assets list

  # Scenario: Create template for a theme
  #   Given I am on the details page of the theme Ocean
  #   When I create a new default layout
  #   And I go to myshop's home page
  #   Then I see my default layout