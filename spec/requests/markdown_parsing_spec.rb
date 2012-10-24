require 'spec_helper'

# These specs test the Newton Markdown parsing customizations.

describe "markdown parsing" do
  context "when post body includes a fenced code block" do
    before(:each) do
      @post = FactoryGirl.create(:post, :published, :body_with_fenced_code_block)
    end
    
    it "HTML output should include a <figure class=\"code\"> element" do
      visit post_url(:year => @post.published_at.year, :month => @post.published_at.month, :slug => @post.slug)
      page.should have_css "article figure.code"
    end
  end
  
  context "when post body includes a blockquote" do
    before(:each) do
      @post = FactoryGirl.create(:post, :published, :body_with_blockquote)
    end
    
    it "HTML output should include a <figure class=\"quote\"> element" do
      visit post_url(:year => @post.published_at.year, :month => @post.published_at.month, :slug => @post.slug)
      page.should have_css "article figure.quote"
    end
  end
  
  context "when post body includes an image" do
    before(:each) do
      @post = FactoryGirl.create(:post, :published, :body_with_image)
    end
    
    it "HTML output should include a <figure class=\"image\"> element" do
      visit post_url(:year => @post.published_at.year, :month => @post.published_at.month, :slug => @post.slug)
      page.should have_css "article figure.image"
    end
  end
end