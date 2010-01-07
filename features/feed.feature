Feature: RSS Feeds
  In order to subscribe to this blog
  As a reader
  I want to be able to use an RSS reader with the site's RSS feed

Scenario: RSS feed returns 10 recent posts
  Given the following posts exist
 | slug   | title   | published_at | excerpt             | body        |
 | post1  | Post 1  | 12/12/09     | This is a test post | Lorem Ipsum |
 | post2  | Post 2  | 12/11/09     | This is a test post | Lorem Ipsum |
 | post3  | Post 3  | 12/10/09     | This is a test post | Lorem Ipsum |
 | post4  | Post 4  | 12/09/09     | This is a test post | Lorem Ipsum |
 | post5  | Post 5  | 12/08/09     | This is a test post | Lorem Ipsum |
 | post6  | Post 6  | 12/07/09     | This is a test post | Lorem Ipsum |
 | post7  | Post 7  | 12/06/09     | This is a test post | Lorem Ipsum |
 | post8  | Post 8  | 12/05/09     | This is a test post | Lorem Ipsum |
 | post9  | Post 9  | 12/04/09     | This is a test post | Lorem Ipsum |
 | post10 | Post 10 | 12/05/09     | This is a test post | Lorem Ipsum |
 | post11 | Post 11 | 12/04/09     | This is a test post | Lorem Ipsum |
  When I am on the rss page
  Then I should see "Post 1"
  And I should see "Post 2"
  And I should see "Post 3"
  And I should see "Post 4"
  And I should see "Post 5"
  And I should see "Post 6"
  And I should see "Post 7"
  And I should see "Post 8"
  And I should see "Post 9"
  And I should see "Post 10"
  But  I should not see "Post 11"



