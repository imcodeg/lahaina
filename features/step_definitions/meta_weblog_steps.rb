require 'meta_weblog_service'
require 'meta_weblog_client'

api=MetaWeblogService.new
client=MetaWebLogClient.new "http://localhost:3000/xmlrpc/api","1","admin","password"

Then /^a post should exist with slug: "([^\"]*)", title: "([^\"]*)", body: "([^\"]*)", is_published: true$/ do |arg1, arg2, arg3|
  post=Post.find_by_slug(arg1)
  assert post.is_published
  assert_equal arg2, post.title
  assert_equal arg3,post.body
end


Then /^I should not be able to login as "([^\"]*)" with password "([^\"]*)"$/ do |arg1, arg2|
    !api.authenticate(arg1,arg2)
end

But /^I should be able to login as "([^\"]*)" with password "([^\"]*)"$/ do |arg1, arg2|
  api.authenticate(arg1,arg2)
end

And /([0-9]+) posts should be returned by metaweblogservice$/ do |count|
  posts=api.getRecentPosts(1,"admin","secret",count)
  posts.count.should==count.to_i
end
Then /^a post with slug "([^\"]*)" should exist$/ do |arg1|
  assert_not_nil Post.find_by_slug(arg1)
end
Then /^1 post should be returned by getPost with "([^\"]*)"$/ do |slug|
  api.getPost(slug, "admin","secret")
end

Then /^the post with slug "([^\"]*)" should not be published$/ do |arg1|
  post=Post.find_by_slug(arg1)
  assert post
  assert !post.is_published
end
Given /^a post exists with slug: "([^\"]*)"$/ do |arg1|
  Post.find_by_slug(arg1)
end
Given /^a post exists with slug: "([^\"]*)", title: "([^\"]*)", body: "([^\"]*)"$/ do |arg1, arg2, arg3|

  assert Post.create!(:slug=>arg1,:title=>arg2,:body=>arg3,:published_at=>arg2)
  
end
Then /^a post should exist with slug: "([^\"]*)", title: "([^\"]*)", body: "([^\"]*)"$/ do |arg1, arg2, arg3|
  Post.find_by_slug_title_body(arg1,arg2,arg3)
end
Given /^a post exists with slug: "([^\"]*)", is_published: true$/ do |arg1|

  Post.create!(:title=>"title",:slug=>arg1,:body=>"body",:is_published=>true)
end
Given /^a post exists with slug: "([^\"]*)", published_at: "([^\"]*)"$/ do |arg1, arg2|

  Post.create!(:title=>"title",:slug=>arg1,:body=>"body",:published_at=>arg2)
end
Given /^([0-9]+) categories exist$/ do |num|
  (1..num.to_i).each do |i|
    Category.create!(:name=>"name"+i.to_s, :slug=>"name"+i.to_s)
  end
end
Given /^I call newPost with "([^\"]*)", body "([^\"]*)", categories "([^\"]*)" and "([^\"]*)"$/ do |title, body, cat1, cat2|

  article=Article.new
  article.title=title
  article.description=body
  article.mt_text_more=body
  article.pubDate=Time.now
  article.categories=[cat1,cat2]
  api.newPost(1,"admin","secret",article,1)
end
Given /^I call newPost with "([^\"]*)", body "([^\"]*)", published set to false$/ do |title, body|
  article=Article.new
  article.title=title
  article.description=body
  article.mt_text_more=body
  api.newPost(1,"admin","secret",article,0)
end
Given /^I call newPost with "([^\"]*)", body "([^\"]*)", categories "([^\"]*)" and "([^\"]*)", published 2 days from now$/ do |title, body, cat1, cat2|
  
  article=Article.new
  article.title=title
  article.description=body
  article.categories=[cat1,cat2]
  article.pubDate=Time.gm(Time.now.year+1,"01","01")
  article.mt_text_more=body
  post=api.newPost(1,"admin","secret",article,1)
  #verify going in
  assert !post.is_published
  
end

And /^the post with slug "([^\"]*)" should belong to categories "([^\"]*)" and "([^\"]*)"$/ do |slug, cat1, cat2|
 post=Post.find_by_slug(slug)
 assert post.categories.find(:name=>cat1)
 assert post.categories.find(:name=>cat2)
end
And /^categories "([^\"]*)" and "([^\"]*)" should have post with slug "([^\"]*)"$/ do |arg1, arg2, arg3|
  cat=Category.find_by_name(arg1)
  assert_not_nil cat.posts(1)
  cat=Category.find_by_name(arg2)
  assert_not_nil cat.posts(1)

end
When /^I call editPost with slug "([^\"]*)" and change the title to "([^\"]*)" and body to "([^\"]*)"$/ do |slug, title, body|
   article=api.getPost(slug, "admin","secret")
   article.title=title
   article.description=body
   article.mt_text_more=body
   article.wp_slug=slug
   api.editPost(slug,"admin","secret",article,1)
end

When /^I call editPost with slug "([^\"]*)" and set published to false$/ do |slug|
  article=api.getPost(slug, "admin","secret")
  api.editPost(slug,"admin","secret",article,0)
end
When /^I call editPost with slug "([^\"]*)" and set published_at to "([^\"]*)"$/ do |slug, pub|
  article=api.getPost(slug, "admin","secret")
  article.pubDate=pub
end
Then /^I should have 2 categories when calling getCategories with api$/ do
  cats=api.getCategories(1,"admin","secret")
  cats.count.should==2
end

When /^I upload a file using the api$/ do
  file_path="#{RAILS_ROOT}/log/development.log"
  bits=File.open(file_path, "r")
  media=MediaObject.new
  media.name=file_path
  media.bits=bits
  uploaded=api.newMediaObject(1,"admin","secret",media)
  
  assert_equal uploaded,"http://localhost:3000/uploads/development.log"
end

Then /^that file should exist in public uploads$/ do
  file_path="#{RAILS_ROOT}/log/cucumber.log"
  expected_path="#{RAILS_ROOT}/public/uploads/cucumber.log"
  assert File.file?(expected_path)
end

Then /^the post with slug "([^\"]*)" should have ([0-9]+) comments$/ do |arg1,num|
  post=Post.find_by_slug(arg1)
  assert_equal num.to_i,post.comments.count
end
