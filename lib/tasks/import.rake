def get_client
  MetaWebLogClient.new('XMLRPC_URL',"1","USER","PASSWORD")
end


task :posts_setpublished, [:is_published] => :environment do |t, args|
 
  puts "resetting all posts published flag to #{args.is_published}"

  posts=Post.all
  posts.each do |p|
    puts "resetting #{p.title} to #{args.is_published}"
    p.is_published=args.is_published
    p.save
  end
    
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
task :synchronize_comments => :environment do
  posts=Post.all
  posts.each do |p|
    puts "getting comments for #{p.title}"
    get_comments(p)
  end
end


desc "Resets all posts in the database with matching slugs to a remote server's settings"
task :synchronize_posts => :environment do
  require 'meta_weblog_client'
  require 'meta_weblog_service'
  require 'xmlrpc/client'
  #grab the remote posts
   puts "connecting to remote blog..."
   from=get_client
  
   #pull all the posts
   puts "getting all posts..."

   posts=from.getRecentPosts(1)
   post_count=posts.count

   puts "found #{posts.count} posts... looping..."
   posts.each do |p|
     article=Article.new(p)
     if(!article.pubDate)
       article.pubDate=article.dateCreated
     end
     puts "looking for post with slug #{article.wp_slug}"
     #get the post with this slug
     existing=Post.find_by_slug(article.wp_slug.downcase)
     
     if(existing)
        puts "Found #{article.wp_slug} - resetting"
        existing.body=article.mt_text_more.gsub(article.description,"")
        existing.title=article.title
        existing.excerpt=article.description
        dc=article.pubDate
        pub_date=Time.gm(dc.year,dc.month,dc.day,15,0,0,0) #don't need time here
        existing.published_at=pub_date
        
        #if needed, you can also grab dates, tags, and reassing categories
        #add as needed
        
        existing.save
        
     end
   end
   puts "Done!"
  
end
desc "Import posts from live blog using XMLRPC" 
task :import_posts => :environment do
  require 'meta_weblog_client'
  require 'meta_weblog_service'
  svc=MetaWeblogService.new
  
  #delete out all posts and categories
  puts "Deleting out all posts and categories..."
  Post.delete_all
  Category.delete_all
  
  puts "connecting to remote blog..."
  from=from=get_client
  
  #pull all the posts
  puts "getting all posts..."
  
  posts=from.getRecentPosts(1000)
  post_count=posts.count
  
  puts "found #{posts.count} posts... looping..."
  
  posts.each do |p|
    
    #push into an Article
    article=Article.new(p)
    
    if(!article.pubDate)
      article.pubDate=article.dateCreated
    end
    
    puts "saving down #{article.title} (#{post_count} to go...)"
    old_post_id=article.postid
    new_post=svc.newPost("1","","",article,1)
    
    get_comments(new_post)  
    
    post_count=post_count-1
  end
  
  puts "All done! There are #{Post.all.count} posts in your blog..."
end

desc "Get comments for a given post"
def get_comments(post)
  require 'meta_weblog_client'
  require 'meta_weblog_service'
 
  puts "connecting to remote blog..."
  from=from=get_client
  post.comments.clear
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
  post.save
end 