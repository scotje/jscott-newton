require 'spec_helper'

describe Admin::BaseHelper do
  describe ".post_types" do
    it "should return an array of post types suitable for a select box helper" do
      types = helper.post_types

      types.should be_an(Array)
      
      # Each type returned should be a 2 member array.
      types.each do |t|
        t.should be_an(Array)
        t.length.should eq(2)
      end
    end
  end
end
