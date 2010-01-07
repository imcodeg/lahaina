Feature: Post details page
  In order to an awesome post
  As a reader
  I want to click a link on the home page and view the post and comment

Scenario: The post should have a wordpress-style title
  Given a post exists with title: "something very groovy", body: "Lorem Ipsum 1", published_at: "12/01/2009"
  Then the post with title "something very groovy" should have url "/2009/12/01/something-very-groovy"

Scenario: Link off of home
  Given a post exists with title: "something very groovy", body: "Lorem Ipsum 1", published_at: "12/01/2009"
  And I am on the home page
  When I follow "something very groovy"
  Then I should see "something very groovy"
  And I should see "Lorem Ipsum 1"

Scenario: Bad link
  Given I go to "/2009/01/01/bad-url"
  Then I should see "404"

Scenario: Category link
  Given a post exists with title: "something very groovy", body: "Lorem Ipsum 1", published_at: "12/01/2009"
  Given I go to "/some-category/something-very-groovy"
  Then I should see "something very groovy"
  And I should see "Lorem Ipsum 1"

Scenario: View Comments
  Given a post exists with title: "something very groovy", body: "Lorem Ipsum 1", published_at: "12/01/2009"
  And the following comments exist for a post with title "something very groovy"
   | author  | created_at | url | email         | body                  |
   | author1 | 12/12/2009 | url | test@test.com | Lorem Ipsum Comment 1 |
   | author2 | 12/13/2009 | url | test1@test.com | Lorem Ipsum Comment 2 |
   | author3 | 12/14/2009 | url | test2@test.com | Lorem Ipsum Comment 3 |
   | author4 | 12/15/2009 | url | test3@test.com | Lorem Ipsum Comment 4 |
  Then the post with title "something very groovy" should have 4 comments
  When I am on the home page
  And I follow "something very groovy"
  Then I should see "author1"
  And I should see "author2"
  And I should see "author3"
  And I should see "author4"


