require 'spec_helper'

describe SubmittedContentLink do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :hyperlink => "value for hyperlink"
    }
  end

  it "should create a new instance given valid attributes" do
    SubmittedContentLink.create!(@valid_attributes)
  end
end
