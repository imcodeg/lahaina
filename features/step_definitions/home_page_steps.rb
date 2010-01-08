Post.delete_all()
Category.delete_all()
User.delete_all()

Given /^the database is empty$/ do
  Post.delete_all()
  Category.delete_all()
  User.delete_all()
end

Given /^the following users exist$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |hash|
    User.create!(hash)
  end
end

Given /^the following posts exist$/ do |table|

  table.hashes.each do |hash|
    Post.create!(hash)
  end
end
Given /^the following categories exist$/ do |table|
  table.hashes.each do |hash|
    Category.create!(hash)
  end
end


Then /^([0-9]+) posts should exist$/ do |num|
  
  Post.all().count.should==num.to_i
end

Given /^([0-9]+) posts exist$/ do |num|
  [0..num.to_i].each do
    Post.create!(:title=>"title", :body=>"body")
  end
end
Then /^category "([^\"]*)" should have ([0-9]+) posts$/ do |arg1,num|
  cat =Category.find_by_slug(arg1)
  assert_not_nil cat
  assert_equal num.to_i,cat.articles.count
end
 
 Given /^([0-9]+) posts exist with category "([^\"]*)", title stub "([^\"]*)"$/ do |num,arg1, arg2|
   #clear existing posts
   
   (1..num.to_i).each do |index|
     title="#{arg2} "+index.to_s
     the_date="12/#{index}/09"
     post=Post.new(:title=>title, :body=>"body", :published_at=>the_date, :is_published=>true)   
     post.slug=post.create_slug(title)
     assert post.save
     Category.categorize(arg1, post)
     
      
   end
   cat=Category.find_by_slug(arg1)
    
  assert_equal 10, cat.posts(10).count
  
 end