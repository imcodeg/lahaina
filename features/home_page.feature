Feature: Home page features
  In order to view all the awesome stuff on the home page
  As a reader
  I want view recent posts, all categories, contact link, search link, and rss feed

Scenario: View Category list 
  Given the following categories exist
 | slug     | name     |
 | subsonic | SubSonic |
 | opinion  | Opinion  |
 | mvc-storefront | MVC Storefront |

  When I am on the home page
  Then I should see "SubSonic"
  And I should see "Opinion"
  And I should see "MVC Storefront"


Scenario: See search prompt
  Given I am on the home page
  Then I should see "Search the Archives"


Scenario: View Last Five Posts sorted by descending data
Given the following posts exist
 | slug  | title  | published_at | excerpt             | body        | is_published |
 | post1 | Post 1 | 12/12/09     | This is a test post | Lorem Ipsum | true         |
 | post2 | Post 2 | 12/11/09     | This is a test post | Lorem Ipsum | true         |
 | post3 | Post 3 | 12/10/09     | This is a test post | Lorem Ipsum | true         |
 | post4 | Post 4 | 12/09/09     | This is a test post | Lorem Ipsum | true         |
 | post5 | Post 5 | 12/08/09     | This is a test post | Lorem Ipsum | true         |
 | post6 | Post 6 | 12/07/09     | This is a test post | Lorem Ipsum | true         |
  When I am on the home page
  Then I should see "Post 1"
  And I should see "Post 2"
  And I should see "Post 3"
  And I should see "Post 4"
  And I should see "Post 5"
  And I should not see "Post 6"

Scenario: See a link to all posts
  Given I am on the home page
  Then I should see "More >>"



