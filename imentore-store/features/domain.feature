Feature: Domain

  Background:
    Given there is a store MyShop
    And I am on the page to create new domain
    And I create myshop.com domain
    And I should see myshop.com created

  Scenario: Create Domain
    Given I am on the page to create new domain
    When I create myshop.com domain
    Then I should see myshop.com created

  Scenario: Access Domain created
    And I access www.myshop.com domain
    Then I should see MyShop home page

  Scenario: Destroy domain created
    And I am on the page to create new domain
    And I should see myshop.com created
    When I delete myshop.com
    Then I shouldn't see myshop.com





