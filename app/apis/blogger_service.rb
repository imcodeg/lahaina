class BlogInfo < ActionWebService::Struct
  member :url,      :string
  member :blogid,   :string
  member :blogName, :string
end
class UserInfo < ActionWebService::Struct
  member :userid, :string
  member :firstname, :string
  member :lastname, :string
  member :nickname, :string
  member :email, :string
  member :url, :string
end

class BloggerApi < ActionWebService::API::Base
  inflect_names false
 
  api_method :deletePost,
    :expects => [ {:appkey => :string}, {:postid => :int}, {:username => :string}, {:password => :string},
                  {:publish => :bool} ],
    :returns => [:bool]
 
  api_method :getUserInfo,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [UserInfo]
 
  api_method :getUsersBlogs,
    :expects => [ {:appkey => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[BlogInfo]]
 
end

class BloggerService < XMLRPCService
  web_service_api BloggerApi
  def getUserInfo(appkey, username, password)
      authenticate(username,password)
      UserInfo.new(
        :userid => username,
        :firstname => username,
        :lastname => "",
        :nickname => "",
        :email => "",
        :url => Blog.url
      )

    end

    def getUsersBlogs(appkey, username, password)
      authenticate(username,password)
      
          [BlogInfo.new(
            :url      => Blog.url,
            :blogid   => "1",
            :blogName => Blog.title
          )]
    end
    
    def deletePost(appkey, postid, username, password, publish)
       authenticate(username,password)
       post=Post.find(postid)
       if(post)
          post.destroy
       else
          raise "Can't find post with #{postid}"
       end
       true
    end
end
