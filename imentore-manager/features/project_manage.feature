Feature: management Project Deal

  Background:
    Given I am authenticated

  Scenario: Add Project
    Given I am new project page
    And I am create a project
    Then I should see project listed

  Scenario: Made a propose to a project
    Given I have a project created
    And I made a propose to the project
    Then I should see the propose