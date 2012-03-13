Feature: Edit store

  Background:
    Given there is a store MyShop
    And the owner is on its dashboard

  Scenario: Owner can edit her store
    When she access General Settings
    Then she should see the general settings form