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

  Scenario: Destroy domain created
    And I go to the page to create new domain
    And I should see myshop.com created
    When I delete myshop.com
    Then I should not see myshop.com

  Scenario: Create Domain with plesk feature
    And I go to the page to create new domain
    And I create Myshop.com with option hosting
    Then I should see status ok