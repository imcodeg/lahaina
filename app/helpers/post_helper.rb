module PostHelper
  def gravatar(email, options = {}) 
    gravatar_id=Digest::MD5.hexdigest(email)
    "<img src='http://www.gravatar.com/avatar/#{gravatar_id}' rel=gravatar />"
  end

end
