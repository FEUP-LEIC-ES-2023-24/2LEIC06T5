Feature: Nav-bar

  Scenario: Move to Chat Page from Main Page
    Given I am in the "swipe" page
    When I tap the "chat" button in the nav-bar
    Then I expect to be redirected to the "chat" page

  Scenario: Move to Main Page from Chat Page
    Given I am in the "chat" page
    When I tap the "swipe" button in the nav-bar
    Then I expect to be redirected to the "swipe" page
