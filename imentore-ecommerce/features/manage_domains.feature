Feature: Domain

  Background:
    Given there is a store MyShop
    And I go to the page to create new domain
    And I create myshop.com domain
    And I should see myshop.com created

  Scenario: Create Domain
    Given I go to the page to create new domain
    When I create myshop.com domain
    Then I should see myshop.com created

  Scenario: Access Domain created
    And I access www.myshop.com domain
    Then I should see MyShop home page

  Scenario: Destroy domain created
    And I go to the page to create new domain
    And I should see myshop.com created
    When I delete myshop.com
    Then I should not see myshop.com

  Scenario: Create Domain with plesk feature
    And I go to the page to create new domain
    And I create Myshop.com with option hosting
    Then I should see status ok