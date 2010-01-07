class Post 
  include MongoMapper::Document
  
  key   :slug, String, :unique=>true
  key   :title, String, :required=> true
  key   :published_at, Time
  key   :excerpt, String
  key   :body, String, :required=> true
  key   :is_published, Boolean, :default => false
  key   :categorizations, Array, :index =>true
  key   :post_id, Integer
  many  :comments
  
  def pretty_date
    published_at.strftime("%A, %B %d, %Y")
  end
  
  def self.by_category(slug, limit)
    Category.find_by_slug(slug).posts(limit)
  end
  def categories
    cat_ids=categorizations.compact
    Category.all(:id=>cat_ids)
  end
  def clear_categories
    categorizations.clear
  end
  def self.recent_sorted(limit)
     Post.all(:order=>"published_at DESC", :limit=>limit, :is_published=>true)
  end
  def create_slug(str)
    #a slug is a URL-safe string that echoes the title
    #in this method we want to remove any weird punctuation and spaces
    str = str.gsub(/[^a-zA-Z0-9 ]/,"")
    str = str.gsub(/[ ]+/," ")
    str = str.gsub(/ /,"-")
    str.downcase
  end
  def year
    published_at.year.to_s
  end
  def month
    sprintf("%.2d",published_at.month)    
  end
  def day
    sprintf("%.2d",published_at.day)
  end
  def url
    "/#{year}/#{month}/#{day}/#{slug}"
  end
end

