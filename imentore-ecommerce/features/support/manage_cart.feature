Feature: Manage cart

  Background:
    Given there is a store
    And I am on its home page

  Scenario: See empty cart
    When I go to my cart
    Then I see a message saying its empty

  Scenario: List cart items
    Given my cart is not empty
    When I go to my cart
    Then I see the list of items
