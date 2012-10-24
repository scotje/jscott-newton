require 'spec_helper'

describe Admin::PostsController do
  include AdminHelper

  before(:each) do
    test_admin_login
    
    @published_posts = FactoryGirl.create_list(:post, 5, :published)
    @draft_posts = FactoryGirl.create_list(:post, 3, :draft)
  end
  
  describe Admin::PostsController, 'index' do
    context "basic response" do
      before(:each) do 
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template(:index) }
    end
      
    context "published posts" do
      it "should collect all the published posts into @posts" do
        get :index
        
        assigns(:posts).should_not be_nil
        assigns(:posts).length.should eq(@published_posts.length)
      end
      
      it "should sort published posts by published_at in descending order" do
        published_posts_sorted = @published_posts.sort { |a,b| b.published_at <=> a.published_at }
        
        get :index

        assigns(:posts).should eq(published_posts_sorted)
      end
    end
    
    context "draft posts" do
      it "should collect all the draft posts into @posts" do
        get :index, :draft => true
        
        assigns(:posts).should_not be_nil
        assigns(:posts).length.should eq(@draft_posts.length)
      end

      it "should sort draft posts by title in ascending order" do
        draft_posts_sorted = @draft_posts.sort { |a,b| a.title <=> b.title }
        
        get :index, :draft => true

        assigns(:posts).should eq(draft_posts_sorted)
      end
    end
  end
  
  describe Admin::PostsController, 'new' do
    context "basic response" do
      before(:each) do 
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    it "should create a new Post object" do
      get :new
      
      assigns(:post).new_record?.should be_true
    end
    
    it "should set @autosave_url to nil" do
      get :new
      
      assigns(:autosave_url).should be_nil
    end
    
    it "should allow an already instantiated Post object in flash[:post]" do
      post = FactoryGirl.build(:post, :draft)
      flash[:post] = post
      session[:flash] = flash
      
      get :new
      
      assigns(:post).should eq(post)
    end
  end
  
  describe Admin::PostsController, 'create' do
    before(:each) do
      @valid_post_attributes = FactoryGirl.attributes_for(:post)
      @invalid_post_attributes = FactoryGirl.attributes_for(:post, :invalid_slug)
    end
    
    it "should create a new Post object based on the passed parameters" do
      post :create, :post => @valid_post_attributes
      
      should assign_to(:post)
      assigns(:post).title.should eq(@valid_post_attributes[:title])
    end
    
    it "should set the published_at attribute if passed a 'resource_action' of 'publish'" do
      post :create, :post => @valid_post_attributes, :resource_action => 'publish'
      
      assigns(:post).published_at.should_not be_nil
    end
    
    it "should NOT set the published_at attribute if NOT passed a 'resource_action' of 'publish'" do
      post :create, :post => @valid_post_attributes, :resource_action => 'save'
      
      assigns(:post).published_at.should be_nil
    end
    
    context "with valid attributes" do
      it "should create a new Post record" do
        expect {
          post :create, :post => @valid_post_attributes, :resource_action => 'publish'
        }.to change(Post, :count).by(1)
      end

      it "should redirect to posts/index if the post was published" do
        post :create, :post => @valid_post_attributes, :resource_action => 'publish'
        
        should redirect_to(admin_posts_url)
      end
      
      it "should redirect to drafts/index if the post was NOT published" do
        post :create, :post => @valid_post_attributes, :resource_action => 'save'
        
        should redirect_to(admin_drafts_url)
      end
    end
    
    context "with invalid attributes" do
      it "should not create a new Post record" do
        expect {
          post :create, :page => @invalid_post_attributes, :resource_action => 'publish'
        }.to_not change(Post, :count)
      end
      
      it "should unset published_at attribute of @post" do
        post :create, :post => @invalid_post_attributes, :resource_action => 'publish'

        assigns(:post).published_at.should be_nil
      end
      
      it "should put the invalid @post object into the flash" do
        post :create, :post => @invalid_post_attributes, :resource_action => 'publish'

        flash[:post].should_not be_nil
        flash[:post][:title].should eq(@invalid_post_attributes[:title])
      end
      
      it "should redirect to new_admin_draft_url" do
        post :create, :post => @invalid_post_attributes, :resource_action => 'publish'
        
        should redirect_to(new_admin_draft_url)
      end
    end
  end
  
  describe Admin::PostsController, 'edit' do
    before(:each) do
      @published_post = FactoryGirl.create(:post, :published)
      @draft_post = FactoryGirl.create(:post, :draft)
    end
    
    context "basic response" do
      before(:each) do 
        get :edit, :id => @published_post.id
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
    
    it "should load the given Post into the @post variable" do
      get :edit, :id => @published_post.id
      
      should assign_to(:post).with(@published_post)
    end
    
    context "published post" do
      before(:each) do
        get :edit, :id => @published_post.id
      end

      it "should assign @autosave_url to nil" do
        should assign_to(:autosave_url).with(nil)
      end
    end
    
    context "draft post" do
      before(:each) do
        get :edit, :id => @draft_post.id
      end
      
      it "should assign @autosave_url to admin_draft_url for post" do
        should assign_to(:autosave_url).with(admin_draft_url(@draft_post))
      end
    end
  end

  describe Admin::PostsController, 'update' do
    before(:each) do
      @valid_post_attributes = FactoryGirl.attributes_for(:post)
      @invalid_post_attributes = FactoryGirl.attributes_for(:post, :invalid_slug)
      
      @published_post = FactoryGirl.create(:post, :published)
      @draft_post = FactoryGirl.create(:post, :draft)
    end
    
    it "should load the given Post into @post" do
      put :update, :id => @published_post.id, :post => @valid_post_attributes
      
      should assign_to(:post).with_kind_of(Post)
      assigns(:post).id.should eq(@published_post.id)
    end
    
    it "should update @post with the passed attributes" do
      put :update, :id => @published_post.id, :post => @valid_post_attributes
      
      assigns(:post).title.should eq(@valid_post_attributes[:title])
    end
    
    it "should set the published_at attribute if passed a 'resource_action' of 'publish'" do
      put :update, :id => @draft_post.id, :post => @valid_post_attributes, :resource_action => 'publish'
      
      assigns(:post).published_at.should_not be_nil
    end
    
    it "should un-set the published_at attribute if passed a 'resource_action' of 'unpublish'" do
      put :update, :id => @published_post.id, :post => @valid_post_attributes, :resource_action => 'unpublish'
      
      assigns(:post).published_at.should be_nil
    end

    context "with valid attributes" do
      it "should update the attributes of the post" do
        put :update, :id => @published_post.id, :post => @valid_post_attributes, :resource_action => 'save'
        
        @published_post.reload
        @published_post.title.should eq(@valid_post_attributes[:title])
      end
      
      context "updating published post" do
        before(:each) do
          put :update, :id => @published_post.id, :post => @valid_post_attributes, :resource_action => 'save'
        end
        
        it { should redirect_to(admin_posts_url) }
      end
      
      context "updating draft post" do
        before(:each) do
          put :update, :id => @draft_post.id, :post => @valid_post_attributes, :resource_action => 'save'
        end
        
        it { should redirect_to(admin_drafts_url) }
      end
      
      it "should return a JSON response to an AJAX autosave" do
        put :update, :format => :json, :id => @draft_post.id, :post => @valid_post_attributes, :resource_action => 'autosave'
        
        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success')
      end
    end
    
    context "with invalid attributes" do
      it "should not alter the given post's attributes" do
        put :update, :id => @draft_post.id, :post => @invalid_post_attributes, :resource_action => 'save'
        
        @draft_post.reload
        @draft_post.title.should_not eq(@invalid_post_attributes[:title])
      end

      it "should revert any changes to published_at" do
        put :update, :id => @draft_post.id, :post => @invalid_post_attributes, :resource_action => 'publish'
        
        assigns(:post).published_at.should eq(@draft_post.published_at)
      end

      it "should put the invalid @post object into the flash" do
        put :update, :id => @draft_post.id, :post => @invalid_post_attributes, :resource_action => 'save'

        flash[:post].should_not be_nil
        flash[:post][:title].should eq(@invalid_post_attributes[:title])
      end
      
      context "updating published post" do
        before(:each) do
          put :update, :id => @published_post.id, :post => @invalid_post_attributes, :resource_action => 'save'
        end
        
        it { should redirect_to(edit_admin_post_url(@published_post)) }
      end
      
      context "updating draft post" do
        before(:each) do
          put :update, :id => @draft_post.id, :post => @invalid_post_attributes, :resource_action => 'save'
        end

        it { should redirect_to(edit_admin_draft_url(@draft_post)) }
      end
    end
  end

  describe Admin::PostsController, 'destroy' do
    before(:each) do
      @published_post = FactoryGirl.create(:post, :published)
      @draft_post = FactoryGirl.create(:post, :draft)
    end
    
    it "should load the given Post into @post" do
      delete :destroy, :id => @published_post.id
      
      should assign_to(:post).with_kind_of(Post)
      assigns(:post).id.should eq(@published_post.id)
    end
 
    it "should delete the post" do
      expect {
        delete :destroy, :id => @published_post.id
      }.to change(Post, :count).by(-1)
    end

    context "destroying published post" do
      it "should return a JSON response with admin_posts_url for an AJAX request" do
        delete :destroy, :format => :json, :id => @published_post.id

        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success')
        body.should include('redirect_to')
        body['redirect_to'].should eq(admin_posts_url)
      end

      it "should redirect to admin_posts_url for a normal request" do
        delete :destroy, :id => @published_post.id
        
        should redirect_to(admin_posts_url)
      end
    end
    
    context "destroying draft post" do
      it "should return a JSON response with admin_drafts_url for an AJAX request" do
        delete :destroy, :format => :json, :id => @draft_post.id

        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success')
        body.should include('redirect_to')
        body['redirect_to'].should eq(admin_drafts_url)
      end

      it "should redirect to admin_posts_url for a normal request" do
        delete :destroy, :id => @draft_post.id
        
        should redirect_to(admin_drafts_url)
      end
    end
  end  
end
