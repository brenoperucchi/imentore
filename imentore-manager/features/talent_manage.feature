Feature: management Talent

  Background:
    Given I am authenticated

  Scenario: Create Talent
    Given I am new talent page
    And I am create talent service
    Then I should see listed dashboard deal