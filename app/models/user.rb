class User
  include MongoMapper::Document
  
  key   :username, String, :required=> true
  key   :password, String
  key   :site_url, String, :required=> true
  
end
