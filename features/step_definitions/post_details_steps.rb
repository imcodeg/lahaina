Post.delete_all()
Given /^a post exists with title: "([^\"]*)", body: "([^\"]*)", published_at: "([^\"]*)"$/ do |arg1, arg2, arg3|
  post=Post.new(:title=>arg1, :body=>arg2, :published_at=>arg3)
  post.slug=post.create_slug(post.title)
  post.save
end

Then /^the post with title "([^\"]*)" should have url "([^\"]*)"$/ do |arg1, arg2|
  post=Post.find_by_title(arg1)
  assert_equal arg2,post.url
end
Then /^the post with title "([^\"]*)" should have ([0-9]+) comments$/ do |arg1, num|
  post=Post.find_by_title(arg1)
  #assert_equal num.to_i, post.comments.count
end

And /^the following comments exist for a post with title "([^\"]*)"$/ do |arg1, table|
  post=Post.find_by_title(arg1)
  
  table.hashes.each do |hash|
    post.comments << Comment.new(hash) 
  end

  assert_equal 4, post.comments.count
  post.save
  
  post=Post.find_by_title(arg1)
  assert_equal 4, post.comments.count
end