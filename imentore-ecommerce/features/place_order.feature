Feature: Place an order

  Background:
    Given there is a store
    And I am on its home page
    And my cart is not empty

  Scenario: Checkout process
    When I go to the checkout page
    And I fill in my contact and payment information
    When I place the order
    Then I see order receipt
