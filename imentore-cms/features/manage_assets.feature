Feature: Manage Assets

  Background:
    Given there is a store
    And I am logged in as the owner


  Scenario: Create Asset
    Given I am at the green theme detalis page
    Then I should create new asset

  Scenario: Destroy Asset
    Given I am at the green theme detalis page
    Then I should destroy the asset