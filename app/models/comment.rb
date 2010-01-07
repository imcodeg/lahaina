class Comment
  include MongoMapper::EmbeddedDocument
  
  key :author, String, :required=>true
  key :url, String
  key :created_at, Date
  key :body, String, :required=>true
  key :email, String, :required=>true
  key :ip, String
end