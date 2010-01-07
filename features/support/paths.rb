module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /contact/
      '/contact'
      
    when /resume/
      '/resume'
    when 'the rss page'
      '/rss'
    when /(.*)\/bad-url/
      '/2009/01/01/bad-url'
      
    when /(.*)\/something-very-groovy/
      '/some-category/something-very-groovy'
      
   when /the (.+) page/
      category_path(:slug=>$1)
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
