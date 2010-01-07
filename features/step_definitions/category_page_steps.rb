And /^I should be able to get ([0-9]+) posts by category (.+)$/ do |num, slug|
  cat=Category.find_by_slug(slug)
  assert_equal num.to_i, cat.posts(num).count
  
  posts=Post.by_category(slug)
  assert_equal num.to_i,posts.count
end