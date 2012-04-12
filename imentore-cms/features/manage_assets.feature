Feature: Manage Assets

  Background:
    Given there is a store
    And I am logged in as the owner

  Scenario: Create Asset
    Given I am at the green theme detalis page
    When I create new asset
    Then I see it in the assets list

  Scenario: Delete Asset
    Given there is the favicon image
    And I am at the green theme detalis page
    When I delete it
    Then it does not appear in the assets list
