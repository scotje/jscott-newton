require 'spec_helper'

describe Post do
  describe "accessibility" do
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:slug) }
    it { should allow_mass_assignment_of(:post_type) }
    it { should allow_mass_assignment_of(:body) }
    it { should allow_mass_assignment_of(:published_at) }
    
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:post_type) }
    
    it "should allow slug with a valid format" do
      post = FactoryGirl.build(:post)
      post.slug = 'this-is-a-valid-slug'
      post.should be_valid
    end
    
    it "should reject slug with an invalid format" do
      should validate_format_of(:slug).not_with('Invalid Slug With Spaces!').with_message(/contains invalid characters for a post slug/)
    end
    
    it "should allow valid values for post_type" do
      should allow_value('link').for(:post_type)
      should allow_value('prose').for(:post_type)
      should allow_value('picture').for(:post_type)
      should allow_value('video').for(:post_type)
    end
    
    it "should reject invalid values for post_type" do
      should_not allow_value('bacon').for(:post_type)
    end
    
    context "published post" do
      subject do
        FactoryGirl.create(:post)
      end
      
      it { should validate_presence_of(:body).with_message("can't be blank for published posts") }
    end
  end
  
  describe "scopes" do
    before(:each) do
      @published_posts = FactoryGirl.create_list(:post, 5)
      @draft_posts = FactoryGirl.create_list(:draft_post, 3)
    end
    
    describe ".published" do
      before(:each) do
        @results = Post.published.all
      end
      
      it "should collect the correct number of posts" do
        @results.length.should eq(@published_posts.length)
      end
      
      it "should return an array of posts" do
        @results.should be_an(Array)
        
        @results.each do |p|
          p.should be_an(Post)
        end
      end
      
      it "should not include any draft posts" do
        @results.each do |p|
          p.published_at.should_not be_nil
        end
      end
    end
    
    describe ".draft" do
      before(:each) do
        @results = Post.draft.all
      end
      
      it "should collect the correct number of posts" do
        @results.length.should eq(@draft_posts.length)
      end
      
      it "should return an array of posts" do
        @results.should be_an(Array)

        @results.each do |p|
          p.should be_an(Post)
        end
      end
      
      it "should not include any published posts" do
        @results.each do |p|
          p.published_at.should be_nil
        end
      end
    end
    
    describe ".published_in_year_and_month" do
      before(:each) do
        @july_2012_posts = FactoryGirl.create_list(:post, 4, :published_at => Time.local(2012, 7, 15))
        @results = Post.published_in_year_and_month(2012,7).all
      end
      
      it "should collect the correct number of posts" do
        @results.length.should eq(@july_2012_posts.length)
      end
      
      it "should return an array of posts" do
        @results.should be_an(Array)

        @results.each do |p|
          p.should be_an(Post)
        end
      end
      
      it "should not include any draft posts" do
        @results.each do |p|
          p.published_at.should_not be_nil
        end
      end
      
      it "should only include posts from the specified year and month" do
        @results.each do |p|
          (Time.local(2012,7,1)..Time.local(2012,7,31)).should cover(p.published_at)
        end
      end
    end
  end
  
  describe ".published?" do
    before(:each) do
      @post = FactoryGirl.create(:post)
      @draft = FactoryGirl.create(:draft_post)
    end
    
    it "should return true for a published post" do
      @post.published?.should be_true
    end
    
    it "should return false for a draft post" do
      @draft.published?.should be_false
    end
  end
end
