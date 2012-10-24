require 'spec_helper'

describe PostsController do
  before(:each) do 
    @posts = FactoryGirl.create_list(:post, 8, :published)
  end

  describe PostsController, '#index' do
    context "basic response" do
      before(:each) do 
        get :index
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:posts) }
      it { should render_template(:index) }
    end
    
    it "should collect the correct number of posts" do
      get :index
      assigns(:posts).length.should eq(@posts.length)
    end
    
    it "should not collect draft posts" do
      FactoryGirl.create(:post, :draft)
      get :index
      
      assigns(:posts).length.should eq(@posts.length)
    end
  end

  describe PostsController, '#list' do
    context "month archive" do
      before(:each) do
        @july_2012_posts = FactoryGirl.create_list(:post, 3, :published_at => Time.local(2012, 7, 15))
        get :list, :month => '07', :year => '2012'
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:posts) }
      it { should render_template(:list) }
      
      it "should collect the correct number of posts for July 2012" do
        assigns(:posts).length.should eq(@july_2012_posts.length)
      end
    end
    
    context "tag archive" # Post tagging is not yet implemented.
    
    context "type archive" do
      before(:each) do
        @picture_posts = FactoryGirl.create_list(:post, 2, :published, :post_type => 'picture')
        get :list, :type => 'picture'
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:posts) }
      it { should render_template(:list) }
      
      it "should collect the correct number of posts with type 'picture'" do
        assigns(:posts).length.should eq(@picture_posts.length)
      end
    end
  end
  
  describe PostsController, '#show' do
    context "for a published post" do
      before(:each) do
        @post = FactoryGirl.create(:post, :published)
        get :show, :year => @post.published_at.year, :month => @post.published_at.month.to_s.rjust(2, '0'), :slug => @post.slug
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:post) }
      it { should render_template(:show) }
      
    end

    it "should redirect to a published post even when passed a single digit value for month" do
      @post = FactoryGirl.create(:post, :published_at => Time.local(2012,7,15))
      get :show, :year => '2012', :month => '7', :slug => @post.slug
      
      should { redirect_to(post_url(@post)) }
    end
    
    context "for an unpublished post" do
      before(:each) do
        @draft_post = FactoryGirl.create(:post, :draft)
      end
      
      it "should raise a RecordNotFound exception" do
        expect {
          get :show, :year => @draft_post.created_at.year, :month => @draft_post.created_at.month, :slug => @draft_post.slug
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
