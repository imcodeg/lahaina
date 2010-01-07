require 'spec_helper'

describe Post do
  before(:each) do
    @valid_attributes = {
      :slug => "value for slug",
      :title => "value for title",
      :published_at => Date.today,
      :excerpt => "value for excerpt",
      :body => "value for body"
    }
  end

  it "should create a new instance given valid attributes" do
    Post.create!(@valid_attributes)
  end
end
