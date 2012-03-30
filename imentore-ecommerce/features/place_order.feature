Feature: Place an order

  Background:
    Given there is a store
    And my cart is not empty

  @wip
  Scenario: Checkout process
    When I go to my cart
    And I click on the checkout button
    And I fill in my contact and payment information
    When I place the order
    Then I see order receipt
