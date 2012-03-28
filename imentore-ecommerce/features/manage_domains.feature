Feature: Manage domains

  Background:
    Given there is a store
    And I am logged in as the owner

  Scenario: Create domain
    When I create a new domain
    Then it appears in the domains list

  Scenario: Access store using custom domain
    Given the store owns the domain myshop.com
    When I go to myshop.com
    Then I see the store's home page

  Scenario: Delete domain
    Given the store owns the domain myshop.com
    When I go to the domain listing
    Then I can delete it

  Scenario: Create mail domain
    Given the store owns domain hosting created 
    When I go to the domain mail listing
    Then I see the domain mail account list 
  