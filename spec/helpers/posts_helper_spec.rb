require 'spec_helper'

describe PostsHelper do
  describe "no_posts_excuse" do
    it "returns a string" do
      helper.no_posts_excuse.should_not be_nil
    end
  end
end
