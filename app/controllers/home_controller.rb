class HomeController < ApplicationController
  def resume
  end

  def contact
  end

  def index
    @categories=Category.all
    @posts=Post.recent_sorted(5)
    
    @subsonic=Category.find_by_slug("subsonic")
    @storefront=Category.find_by_slug("mvc-storefront")
    @opinion=Category.find_by_slug("opinion")
    
  end

end
