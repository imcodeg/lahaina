Feature: Top level pages
  In order to know more about Author and contact him
  As a reader
  I want to see their resume and send him a note via email

  Scenario: Contact page exists
    When I am on contact
    Then I should see "Hello"
  
  Scenario: Send Author a message
    Given I am on contact
    When I fill in "name" with "Joe Blow"
    And I fill in "message" with "Hello"
    And I press "submit"
    Then a test message should be sent
  
  Scenario: Resume page exists
    When I am on resume
    Then I should see "My Resume"
  
  
  
  
  
