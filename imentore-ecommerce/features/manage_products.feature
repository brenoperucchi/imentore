Feature: Manage products

  Background:
    Given there is a store
    And I am logged in as the owner

  Scenario: Create product
    When I create a product
    Then it appears in the product list

  Scenario: Products list in root
    When I go to myshop.imentore.dev
    Then I see the products list

  Scenario: Add Image to product variant
    When I edit a product variant

