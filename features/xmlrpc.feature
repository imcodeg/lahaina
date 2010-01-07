Feature: Xmlrpc access
  In order to manage posts
  As an admin
  I want to be able to connect to the site using xmlrpc

Scenario: Get recent posts
	Given there are 10 posts in the development database
	Then I should have 10 posts for getRecentPosts
	
Scenario: Get single post
  When I getPost using slug "microsoft-subsonic-and-me" I should have 1 post

Scenario: Add new post
  When I add a new post with title "Delete me" and body "Lorem Ipsum"
  Then I getPost using slug "delete-me" I should have 1 post










  
