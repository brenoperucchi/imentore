Feature: Access Domain Created

  Background:
    Given there is a store MyShop
    And I am on the page to create new domain
    And I create myshop.com domain
    And I should see myshop.com created


  Scenario: Access Store by domain using myshop.com
    Given I am on the page to create new domain
    And I create myshop.com domain
    And I should see myshop.com created
    And I access www.myshop.com domain
    Then I should see MyShop home page