Feature: Metaweblog Support
  In order to  manage posts
  As an author
  I want to be able to use popular blogging author tools to manage my blog remotely

Background:
	Given the following users exist
	  | username | password |
	  | admin    | secret   |

Scenario: API should validate user

  Then I should not be able to login as "bob" with password "ninja"
  But I should be able to login as "admin" with password "secret"

Scenario: Retrieve 10 recent posts
	Given the following posts exist
	 | title    | body           | published_at | slug   |
	 | title 1  | Lorem Ipsum 1  | 12/12/2009     | slug1  |
	 | title 2  | Lorem Ipsum 2  | 12/13/2009     | slug2  |
	 | title 3  | Lorem Ipsum 3  | 12/14/2009     | slug3  |
	 | title 4  | Lorem Ipsum 4  | 12/15/2009     | slug4  |
	 | title 5  | Lorem Ipsum 5  | 12/16/2009     | slug5  |
	 | title 6  | Lorem Ipsum 6  | 12/17/2009     | slug6  |
	 | title 7  | Lorem Ipsum 7  | 12/18/2009     | slug7  |
	 | title 8  | Lorem Ipsum 8  | 12/19/2009     | slug8  |
	 | title 9  | Lorem Ipsum 9  | 12/20/2009     | slug9  |
	 | title 10 | Lorem Ipsum 10 | 12/21/2009     | slug10 |
	 | title 11 | Lorem Ipsum 11 | 12/22/2009     | slug11 |
	 | title 12 | Lorem Ipsum 12 | 12/23/2009     | slug12 |
	 | title 13 | Lorem Ipsum 13 | 12/24/2009     | slug13 |

	Then 13 posts should exist
    And 10 posts should be returned by metaweblogservice
   

Scenario: Create new post
  Given I call newPost with "create new post", body "body", categories "cat1" and "cat2"
  Then a post should exist with slug: "create-new-post", title: "create new post", body: "body", is_published: true
  And the post with slug "create-new-post" should belong to categories "cat1" and "cat2"
  And categories "cat1" and "cat2" should have post with slug "create-new-post"

Scenario: Create new post with future publish date
  Given I call newPost with "future post", body "body", categories "cat1" and "cat2", published 2 days from now
  Then a post with slug "future-post" should exist  
  And the post with slug "future-post" should not be published
  
Scenario: Create new post with published off
  Given I call newPost with "publish false", body "body", published set to false
  Then the post with slug "publish-false" should not be published

Scenario: Edit Post
  Given a post exists with slug: "edit-post", title: "edit post", body: "Lorem Ipsum 1"
  When I call editPost with slug "edit-post" and change the title to "Title 99" and body to "Yippy Skippy"
  Then a post should exist with slug: "slug1", title: "Title 99", body: "Yippy Skippy"

Scenario: Take post offline
  Given a post exists with slug: "offline-post", is_published: true
  When I call editPost with slug "offline-post" and set published to false
  Then the post with slug "offline-post" should not be published

Scenario: Change publish date
  Given a post exists with slug: "pub-date", published_at: "1/1/2000"
  When I call editPost with slug "pub-date" and set published_at to "1/1/2090"
  Then the post with slug "pub-date" should not be published 

Scenario: Get all categories
  Given the database is empty
  And 2 categories exist
  Then I should have 2 categories when calling getCategories with api

Scenario: Uploading new file
  When I upload a file using the api
  Then that file should exist in public uploads

Scenario: Categories
  Given the database is empty
  Given the following categories exist
	| slug     | name     |
	| subsonic | SubSonic |
	| opinion  | Opinion  |
	| mvc-storefront | MVC Storefront |
  Then I should have 3 categories with getCategories


























  
