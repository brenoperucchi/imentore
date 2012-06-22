Feature: Manage Customer
  Background:
    Given there is a store
    Given I am on its home page

  Scenario: Create new Customer
    Given I go to create new customer
    Then I should see notification of created customer

  Scenario: Login Dashboard Customer
    Given I go to login in customer dashboard
    Then I see the Dashboard Gretting
