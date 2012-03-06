Feature: Access a store

  Background:
    Given there is a store MyShop
    # And they also own the domain myshop.dev

  Scenario: Access via myshop.imentore.dev
    When I go to myshop.imentore.dev
    Then I see the MyShop home page

  # Scenario: Access via myshop.dev
  #   When I go to myshop.dev
  #   Then I see the MyShop home page

  Scenario: Access a store that do not exists
    When I go to a store that do not exists
    #Then I see a store not found error page