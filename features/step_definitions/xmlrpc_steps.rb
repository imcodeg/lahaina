require 'meta_weblog_client'
require 'meta_weblog_service'
client=MetaWebLogClient.new('http://localhost:3000/xmlrpc/api',"1","","")
Given /^there are 10 posts in the development database$/ do
  
  #I know this is silly, but we're connecting to our server and there should be some test
  #data in there.
  
  true
end
Then /^I should have ([0-9]+) posts for getRecentPosts$/ do |num|
  posts=client.getRecentPosts(10)
  assert_equal(num.to_i,posts.count)
end

When /^I getPost using slug "([^\"]*)" I should have 1 post$/ do |arg1|
  post=client.getPost(arg1)
  assert_not_nil(post)
  article=Article.new(post) 
  assert_equal arg1, article.wp_slug
end

When /^I add a new post with title "([^\"]*)" and body "([^\"]*)"$/ do |arg1, arg2|
  
  client.newPost(
    :title=>arg1,
    :description=>arg2,
    :mt_text_more=>arg2
  )
  
end