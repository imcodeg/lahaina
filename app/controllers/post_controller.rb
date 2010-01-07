class PostController < ApplicationController
  layout "application", :except => [:rss]
  def index
    @categories=Category.all
    slug=params[:slug]
    if(slug)
      @posts=Post.by_category(slug, 1000)
    else
      @posts=Post.recent_sorted(10)
    end
    
  end


  def rss  
    @posts=Post.recent_sorted(10)
  end
  def show
    @post=Post.find_by_slug(params[:slug])
    #if !@post
    #  render "404"
    #end
  end

end