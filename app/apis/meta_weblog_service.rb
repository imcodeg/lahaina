class CategoryInfo < ActionWebService::Struct

    member :categoryId,       :string
    member :parentId,       :string
    member :description,       :string
    member :categoryName,       :string
    member :title,       :string
    member :htmlUrl,       :string
    member :rssUrl,       :string
end

class ArticleComment< ActionWebService::Struct
    member :date_created_gmt, :date
    member :user_id,          :string
    member :comment_id,       :string
    member :comment_parent,   :string
    member :status,           :string
    member :content,          :string
    member :link,             :string
    member :post_id,          :string
    member :post_title,       :string
    member :author,           :string
    member :author_url,       :string
    member :author_email,     :string
    member :author_ip,        :string
    member :type,             :string
end

class Article < ActionWebService::Struct
  member :description,        :string
  member :title,              :string
  member :postid,             :string
  member :url,                :string
  member :link,               :string
  member :permaLink,          :string
  member :categories,         [:string]
  member :mt_text_more,       :string
  member :mt_basename,       :string
  member :mt_excerpt,         :string
  member :mt_keywords,        :string
  member :mt_allow_comments,  :int
  member :mt_allow_pings,     :int
  member :mt_convert_breaks,  :string
  member :dateCreated,        :time
  member :wp_slug,            :string
  member :pubDate,            :time
  member :date_created_gmt,    :time
end



class MediaObject < ActionWebService::Struct
    member :bits, :string
    member :name, :string
    member :type, :string
end

class Url < ActionWebService::Struct
    member :url, :string
end

class MetaWeblogApi < ActionWebService::API::Base
  inflect_names false

  api_method :getRecentPosts,
    :expects => [{:blogid=>:string}, {:username=>:string}, {:password=>:string}, {:numberOfPosts=>:string}],
    :returns => [[Article]]
  
  api_method :getPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [Article]
  
  api_method :newPost,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:struct => Article}, {:publish => :int} ],
    :returns => [:string]
    
  api_method :editPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string}, {:struct => Article}, {:publish => :int} ],
    :returns => [:bool]
  
  api_method :getCategories,
     :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string} ],
     :returns => [[CategoryInfo]]
     
  api_method :newMediaObject,
     :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:data => MediaObject} ],
     :returns => [Url]

end

class MetaWeblogService < XMLRPCService
   web_service_api MetaWeblogApi
     
   def upload_path(file = nil)
       "#{RAILS_ROOT}/public/uploads/#{file.nil? ? file.basename : file}"
   end
   
   def newMediaObject(blogid,username,password,data)
      
      authenticate(username,password)
       
      root_url=Rails.env=="production" ? Blog.url : "http://localhost:3000"

      upload_dir="#{RAILS_ROOT}/public/system/uploads/"
      upload_path=upload_dir+File.basename(data.name)

      # create the public/uploads dir if it doesn't exist
      FileUtils.mkdir(upload_dir) unless File.directory?(upload_dir)

    
      #if the file is there, delete it
      if(File.file?(upload_path))
        File.delete(upload_path)
      end
    
      #save it down
      File.open(upload_path, "wb") { |f| f.write(data.bits) }
      
      #make sure it's readable
      File.chmod(0777, upload_path)

      #return an absolute URL to the item
      url="#{Blog.url}/system/uploads/#{File.basename(data.name)}"
      Url.new(:url=>url)
   end

   def getRecentPosts(blogid, username, password, limit)
     
     authenticate(username,password)
     posts=Post.find(:all, :limit=>limit, :order=>"published_at DESC")
     articles=posts.collect { |c| struct_from(c) }
     articles
     
   end
   
   def getCategories(blogid,username,password)
     cats=Category.all
     cats.collect do |c|
       CategoryInfo.new(
          :categoryId=>c.id,
          :parentId=>'',
          :description=>c.name,
          :categoryName=>c.name,
          :title=>c.name,
          :htmlUrl=>"#{Blog.url}/category/#{c.name}",
          :rssUrl=>''
       )
     end

   end
   
   def editPost(slug, username, password, hash, publish)
     authenticate(username,password)
     article=Article.new(hash)
     
     post=Post.find_by_slug(article.wp_slug)
     
     if(post)  
       bind_post(post,article)
       if(publish==0)
         post.is_published=false
       end
       
       if(!post.save)
         raise "Can't save edits to post...#{post.inspect}"
       end
       
     end
     true
   end
   
   def newPost(blogid, username,password,hash,publish)
 
      authenticate(username,password)
      article=Article.new(hash)
      post=Post.new
      bind_post(post,article)
      
      if(publish==0)
        post.is_published=false
      end
    
      if(!post.save)
        raise "Can't save new post...#{post.inspect}"
      end
      assign_categories(article,post)
      "#{Blog.url}#{post.url}"   
   end
   
   def assign_categories(article, post)
     post.clear_categories
     Category.clear_posts(post)
     
     if(!article.categories.blank?)
       article.categories.each do |cat|
         Category.categorize(cat,post)
       end
     end
   end
   
   def getPost(id, username,password)
     authenticate(username,password)
     post=Post.find(id)

     if(!post)
      raise "Can't find post with slug #{slug}"
     end
     struct_from(post)
   end

   def bind_post(post,article)
     post.is_published=true
     #some left/right
     post.title=article.title
     
     if(!post.published_at)
       post.published_at=Time.now
     
     if(!article.wp_slug)
      article.wp_slug=''
     end
     if(article.mt_text_more)
       #the post has been split so pop the description as the excerpt,
       #and the body as the mt_text_more
       post.excerpt=article.description
       post.body=article.mt_text_more
     else
       #just push the whole thing to the body
       post.body=article.description
       post.excerpt=""
     end

     #for posterity
     if(article.postid)
       post.post_id=article.postid.to_i
     end
    
     #reset the pub date if it was passed in
     if(article.date_created_gmt)
       dc=article.date_created_gmt
       pub_date=Time.gm(dc.year,dc.month,dc.day,0,0,0,0) #don't need time here
       post.published_at=pub_date
     end
     
     if(post.published_at>Time.now)
       post.is_published=false
     end

     #set the slug
     if(article.wp_slug!='')
       post.slug=article.wp_slug.downcase
     else
       post.slug=post.create_slug(post.title)
     end

     post
   end
 
   def struct_from(post)
     
       Article.new(
       :description       => post.excerpt,
       :title             => post.title,
       :postid            => post.id.to_s,
       :url               => "#{Blog.url}#{post.url}",
       :link              => "#{Blog.url}#{post.url}",
       :permaLink         => "#{Blog.url}#{post.url}",
       :categories        => post.categories.collect{|c| c.name},
       :mt_text_more      => post.body,
       :mt_excerpt        => "",
       :mt_keywords       => "",
       :mt_allow_comments => 1,
       :mt_allow_pings    => 0,
       :mt_convert_breaks => "",
       :wp_slug           => post.slug,
       :dateCreated       => post.published_at,
       :date_created_gmt  => post.published_at,
       :pubDate           => post.published_at
      )
   end

end