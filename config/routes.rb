ActionController::Routing::Routes.draw do |map|
  map.connect 'contact', :controller=>'home', :action=>'contact'
  map.connect 'resume', :controller=>'home', :action=>'resume'  
  map.connect 'rss', :controller=>'post', :action=>'rss'  
  map.connect 'xmlrpc/api', :controller => "xmlrpc", :action=> "api"
  map.wp_post ':year/:month/:day/:slug', :controller => 'post', :action=> 'show'
  map.category 'category/:slug', :controller => 'post', :action=> 'index'
  map.post_by_category  ':category_slug/:slug', :controller => 'post', :action=> 'show'
  map.search 'search', :controller=> 'post', :action=>'search'
 
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home", :action=> "index"
end
