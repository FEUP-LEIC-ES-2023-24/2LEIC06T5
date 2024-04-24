Feature: Swipe

  Scenario: Accept book offer
    Given I am in the main page
    When I swipe to the "right"
    Then I accept the current book offer

  Scenario: Accept book offer
    Given I am in the main page
    When I tap the "accept" button
    Then I accept the current book offer

  Scenario: Decline book offer
    Given I am in the main page
    When I swipe to the "left"
    Then I decline the current book offer

  Scenario: Decline book offer
    Given I am in the main page
    When I press the "decline" button
    Then I decline the current book offer