
# https://github.com/badeball/cypress-cucumber-preprocessor/issues/1362

@network
Feature: reload-behavior in presence of run hooks
  Scenario: with a BeforeAll
    Given additional preprocessor configuration
      """
      {
        "messages": {
          "enabled": true
        }
      }
      """
    And a file named "cypress/e2e/a.feature" with:
      """
      Feature: a feature
        Scenario: a scenario
          When I navigate to "https://example.com/"
      """
    And a file named "cypress/support/step_definitions/steps.js" with:
      """
      const { When, BeforeAll } = require("@badeball/cypress-cucumber-preprocessor");
      BeforeAll(() => {})
      When("I navigate to {string}", function(url) {
        cy.visit(url)
      })
      """
    When I run cypress
    Then it passes
    And there should be a messages similar to "fixtures/reload-before-all.ndjson"

  Scenario: with a AfterAll
    Given additional preprocessor configuration
      """
      {
        "messages": {
          "enabled": true
        }
      }
      """
    And a file named "cypress/e2e/a.feature" with:
      """
      Feature: a feature
        Scenario: a scenario
          When I navigate to "https://example.com/"
      """
    And a file named "cypress/support/step_definitions/steps.js" with:
      """
      const { When, AfterAll } = require("@badeball/cypress-cucumber-preprocessor");
      AfterAll(() => {})
      When("I navigate to {string}", function(url) {
        cy.visit(url)
      })
      """
    When I run cypress
    Then it passes
    And there should be a messages similar to "fixtures/reload-after-all.ndjson"
