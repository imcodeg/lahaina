xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title Blog.title
    xml.description Blog.tagline
    xml.link root_url
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.published_at.to_s(:rfc822)
        xml.link wp_post_url(:year=>post.year, :month=>post.month, :day=>post.day, :slug=>post.slug)
        xml.guid wp_post_url(:year=>post.year, :month=>post.month, :day=>post.day, :slug=>post.slug)
      end
    end
  end
end