require 'spec_helper'

describe Categorization do
  before(:each) do
    @valid_attributes = {
      :post_id => 1,
      :category_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Categorization.create!(@valid_attributes)
  end
end
