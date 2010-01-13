def get_client
  MetaWebLogClient.new('SERVER XMLRPC URL',"1","user","password")
end

task :downcase_slugs => :environment do 
 
  puts "resetting all posts and category slugs"

  posts=Post.all
  posts.each do |p|
    puts "resetting #{p.title}"
    p.slug.downcase!
    p.save
  end
  
  categories=Category.all
  categories.each do |c|
    puts "resetting #{c.name}"
    c.slug.downcase!
    c.save
  end
end


desc "Resets all posts in the database with matching slugs to a remote server's settings"
task :synchronize_posts => :environment do
  require 'meta_weblog_client'
  require 'meta_weblog_service'
  require 'xmlrpc/client'
  
  puts "connecting to remote blog..."
  from=get_client
  
  posts=from.getRecentPosts(500)
  post_count=posts.count
  
  puts "found #{posts.count} posts... looping..."
  
  posts.each do |p|
    
    #push into an Article
    article=Article.new(p)
    
    post=Post.find_by_slug(article.wp_slug.downcase)
    bind_post_to_article(post,article)
    
    puts "saving down #{article.title} (#{post_count} to go...)"
    post.save
   end
   puts "Done!"
  
end

def bind_post_to_article(post,article)
  post.title=article.title
  post.slug=article.wp_slug.downcase
  post.excerpt=article.description
  post.body=article.mt_text_more
  dc=article.pubDate
  post.published_at=Time.gm(dc.year,dc.month,dc.day,15,0,0,0) #don't need time here
  post.is_published=true
  post.post_id=article.postid
end
  
end

desc "Import posts from live blog using XMLRPC" 
task :import_posts => :environment do
  require 'meta_weblog_client'
  require 'meta_weblog_service'
  svc=MetaWeblogService.new
  
  #delete out all posts and categories
  puts "Deleting out all posts and categories... Rails Environment #{Rails.env}"
  Post.delete_all
  Category.delete_all
  
  puts "connecting to remote blog..."
  from=get_client
  
  #pull all the posts
  puts "getting all posts..."
  
  posts=from.getRecentPosts(500)
  post_count=posts.count
  
  puts "found #{posts.count} posts... looping..."
  
  posts.each do |p|
    
    #push into an Article
    article=Article.new(p)
    
    post=Post.new
    bind_post_to_article(post,article)
    
    #categories
    if(!article.categories.blank?)
      article.categories.each do |cat|
        Category.categorize(cat,post)
      end
    end
    
    puts "saving down #{article.title} (#{post_count} to go...)"
    post.save
    
    puts "getting comments..."
    
    comment_hash=from.getComments(post.post_id.to_s)
    if(comment_hash)
      
      comment_hash.each do |c|
        ac=ArticleComment.new(c)
        comment=Comment.new()
        comment.author=ac.author
        comment.url=ac.author_url
        comment.email=ac.author_email
        comment.body=ac.content
        comment.ip=ac.author_ip
        if(ac.date_created_gmt)
           dc=ac.date_created_gmt
           pub_date=Time.gm(dc.year,dc.month,dc.day,15,0,0,0) #don't need time here
           comment.created_at=pub_date
         end   
        puts "adding comment from #{comment.author}"  
        post.comments << comment
      end
    end
  
    post_count=post_count-1
  end
  
  puts "All done! There are #{Post.all.count} posts in your blog..."
end
