Feature: Categories page
  In order to see posts by category
  As a reader
  I want to have a page where posts are listed in descending order by category, with a list of categories as well

Scenario: title
  Given 10 posts exist with category "cat1", title stub "Spec"
  And 10 posts exist with category "cat2", title stub "Spec2"
  When I am on the cat1 page
  Then category "cat1" should have 10 posts
  And I should be able to get 10 posts by category cat1
  Then I should see "Spec 10"
  And I should see "Spec 1"
  But I should not see "Spec2"



