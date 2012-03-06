Feature: Create

  Background:
    Given there is a store MyShop
    And the owner is on its dashboard

  Scenario: Owner add domain to store
    Given I am on the page to create new domain
    When I create myshop.com domain
    Then I should see myshop.com created