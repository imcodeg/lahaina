require 'xmlrpc/client'
class MetaWebLogClient
  def initialize(server, blogid, username, password)
    @client = XMLRPC::Client.new2(server)
    @blogid = blogid
    @username = username
    @password = password
  end
   def getRecentPosts(limit)
     @client.call('metaWeblog.getRecentPosts', "1", @username,
         @password, limit)
   end
   def getPost(post_id)
     @client.call('metaWeblog.getPost', post_id, @username,
         @password)
   end
   def getComments(post_id)
   
     @client.call('wp.getComments', "1", @username,
          @password, {:post_id=>post_id})
     
   end
   def newPost(post)
      @client.call('metaWeblog.newPost', "1", @username,
           @password, post, 1)
   end
   def addComments(postid, comments)
      @client.call('metaWeblog.addComments', postid, @username,
           @password, comments)
   end
end
