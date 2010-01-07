class Category 
  include MongoMapper::Document
  
  key :name, String
  key :slug, String, :unique=>true
  key :articles, Array, :index=>true
  
  def self.clear_posts(post)
    Category.all().each {|c| c.articles.delete(post.slug)}
  end
  
  def posts(limit=5)
    post_ids=articles.flatten.compact.uniq
    Post.all(:id=>post_ids, :order=>"published_at DESC", :is_published=>true, :limit=>limit)
  end
  
  def clear_posts
    :articles.clear
  end
  
  def self.categorize(name, post)
     #see if it exists
     existing_category=Category.find_by_name(name) || Category.find_by_slug(name)
     
 
     if(!existing_category)
        #if not, add it
       existing_category=Category.create!(:name=>name, :slug=>post.create_slug(name))
     end
     #associate them   
     post.categorizations << existing_category.id
     existing_category.articles << post.id
     
     post.save
     existing_category.save
     
  end

  
end
