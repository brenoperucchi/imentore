Feature: Manage products

  Background:
    Given there is a store
    And I am logged in as the owner

  Scenario: Create product
    When I create a product
    Then it appears in the product list
