Feature: Manage themes

  Background:
    Given there is a store MyShop
    And I am logged in as the MyShop's owner

  Scenario: Create a theme
    When I go to the new theme page
    And create a theme called Ocean
    Then I should see its details page

  Scenario: Create template for a theme
    Given I am on the details page of the theme Ocean
    When I create a new default layout
    And I go to myshop's home page
    Then I see my default layout