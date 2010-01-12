class XMLRPCService < ActionWebService::Base
  
  def authenticate(username, password)
    user=User.find_by_username_and_password(username,password)
    if(!user)
      raise "Invalid login"
    end
  end
end