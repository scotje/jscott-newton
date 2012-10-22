require 'spec_helper'

describe Admin::PagesController do
  include AdminHelper

  before(:each) do
    test_admin_login
    
    @published_pages = FactoryGirl.create_list(:page, 5, :published)
    @draft_pages = FactoryGirl.create_list(:page, 3, :draft)
  end
  
  describe Admin::PagesController, 'index' do
    context "basic response" do
      before(:each) do 
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template(:index) }
    end
      
    it "should collect all the pages into @pages" do
      get :index
        
      assigns(:pages).should_not be_nil
      assigns(:pages).length.should eq(@published_pages.length + @draft_pages.length)
    end
  end
  
  describe Admin::PagesController, 'new' do
    context "basic response" do
      before(:each) do 
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    it "should create a new Page object" do
      get :new
      
      assigns(:page).new_record?.should be_true
    end
    
    it "should set @autosave_url to nil" do
      get :new
      
      assigns(:autosave_url).should be_nil
    end
    
    it "should allow an already instantiated Page object in flash[:page]" do
      page = FactoryGirl.build(:page, :draft)
      flash[:page] = page
      session[:flash] = flash
      
      get :new
      
      assigns(:page).should eq(page)
    end
  end
  
  describe Admin::PagesController, 'create' do
    before(:each) do
      @valid_page_attributes = FactoryGirl.attributes_for(:page)
      @invalid_page_attributes = FactoryGirl.attributes_for(:page, :invalid_slug)
    end
    
    it "should create a new Page object based on the passed parameters" do
      post :create, :page => @valid_page_attributes
      
      should assign_to(:page)
      assigns(:page).title.should eq(@valid_page_attributes[:title])
    end
    
    it "should set the published_at attribute if passed a 'resource_action' of 'publish'" do
      post :create, :page => @valid_page_attributes, :resource_action => 'publish'
      
      assigns(:page).published_at.should_not be_nil
    end
    
    it "should NOT set the published_at attribute if NOT passed a 'resource_action' of 'publish'" do
      post :create, :page => @valid_page_attributes, :resource_action => 'save'
      
      assigns(:page).published_at.should be_nil
    end
    
    context "with valid attributes" do
      it "should create a new Page record" do
        expect {
          post :create, :page => @valid_page_attributes, :resource_action => 'save'
        }.to change(Page, :count).by(1)
      end
      
      it "should redirect to pages/index" do
        post :create, :page => @valid_page_attributes, :resource_action => 'save'
        
        should redirect_to(admin_pages_url)
      end
    end
    
    context "with invalid attributes" do
      it "should not create a new Page record" do
        expect {
          post :create, :page => @invalid_page_attributes, :resource_action => 'publish'
        }.to_not change(Page, :count)
      end

      it "should unset published_at attribute of @post" do
        post :create, :page => @invalid_page_attributes, :resource_action => 'publish'
        
        assigns(:page).published_at.should be_nil
      end
      
      it "should put the invalid @post object into the flash" do
        post :create, :page => @invalid_page_attributes, :resource_action => 'publish'

        flash[:page].should_not be_nil
        flash[:page][:title].should eq(@invalid_page_attributes[:title])
      end
      
      it "should redirect to new_admin_page_url" do
        post :create, :page => @invalid_page_attributes, :resource_action => 'publish'

        should redirect_to(new_admin_page_url)
      end
    end
  end
  
  describe Admin::PagesController, 'edit' do
    before(:each) do
      @published_page = FactoryGirl.create(:page, :published)
      @draft_page = FactoryGirl.create(:page, :draft)
    end
    
    context "basic response" do
      before(:each) do 
        get :edit, :id => @published_page.id
      end

      it { should respond_with(:success) }
      it { should render_template(:edit) }
    end
    
    it "should load the given Page into the @page variable" do
      get :edit, :id => @published_page.id
      
      should assign_to(:page).with(@published_page)
    end
    
    context "published page" do
      before(:each) do
        get :edit, :id => @published_page.id
      end
      
      it "should set @autosave_url to nil" do
        assigns(:autosave_url).should be_nil
      end
    end
    
    context "draft page" do
      before(:each) do
        get :edit, :id => @draft_page.id
      end
      
      it "should set @autosave_url to admin_page_url" do
        assigns(:autosave_url).should eq(admin_page_url(@draft_page))
      end
    end
  end

  describe Admin::PagesController, 'update' do
    before(:each) do
      @valid_page_attributes = FactoryGirl.attributes_for(:page)
      @invalid_page_attributes = FactoryGirl.attributes_for(:page, :invalid_slug)
      
      @published_page = FactoryGirl.create(:page, :published)
      @draft_page = FactoryGirl.create(:page, :draft)
    end
    
    it "should load the given Page into @page" do
      put :update, :id => @published_page.id, :page => @valid_page_attributes
      
      should assign_to(:page).with_kind_of(Page)
      assigns(:page).id.should eq(@published_page.id)
    end

    it "should update @page with the passed attributes" do
      put :update, :id => @published_page.id, :page => @valid_page_attributes
      
      assigns(:page).title.should eq(@valid_page_attributes[:title])
    end

    it "should set the published_at attribute if passed a 'resource_action' of 'publish'" do
      put :update, :id => @draft_page.id, :page => @valid_page_attributes, :resource_action => 'publish'
      
      assigns(:page).published_at.should_not be_nil
    end
    
    it "should un-set the published_at attribute if passed a 'resource_action' of 'unpublish'" do
      put :update, :id => @published_page.id, :page => @valid_page_attributes, :resource_action => 'unpublish'
      
      assigns(:page).published_at.should be_nil
    end

    context "with valid attributes" do
      it "should update the attributes of the page" do
        put :update, :id => @published_page.id, :page => @valid_page_attributes, :resource_action => 'save'
        
        @published_page.reload
        @published_page.title.should eq(@valid_page_attributes[:title])
      end
      
      it "should redirect to admin_pages_url" do
        put :update, :id => @published_page.id, :page => @valid_page_attributes, :resource_action => 'save'
        
        should redirect_to(admin_pages_url)
      end

      it "should return a JSON response to an AJAX autosave" do
        put :update, :format => :json, :id => @draft_page.id, :page => @valid_page_attributes, :resource_action => 'autosave'
        
        response.should be_success
        body = JSON.parse(response.body)
        body.should include('success')
      end
    end
    
    context "with invalid attributes" do
      it "should not alter the given page's attributes" do
        put :update, :id => @draft_page.id, :page => @invalid_page_attributes, :resource_action => 'save'
        
        @draft_page.reload
        @draft_page.title.should_not eq(@invalid_page_attributes[:title])
      end
      
      it "should revert any changes to published_at" do
        put :update, :id => @draft_page.id, :page => @invalid_page_attributes, :resource_action => 'publish'
        
        assigns(:page).published_at.should eq(@draft_page.published_at)
      end

      it "should put the invalid @page object into the flash" do
        put :update, :id => @draft_page.id, :page => @invalid_page_attributes, :resource_action => 'save'

        flash[:page].should_not be_nil
        flash[:page][:title].should eq(@invalid_page_attributes[:title])
      end
      
      it "should redirect back to edit_admin_page_url" do
        put :update, :id => @published_page.id, :page => @invalid_page_attributes, :resource_action => 'save'

        should redirect_to(edit_admin_page_url(@published_page))
      end
    end
  end

  describe Admin::PagesController, 'destroy' do
    before(:each) do
      @published_page = FactoryGirl.create(:page, :published)
    end
    
    it "should delete the page" do
      expect {
        delete :destroy, :id => @published_page.id
      }.to change(Page, :count).by(-1)
    end

    it "should return a JSON response with admin_pages_url for an AJAX request" do
      delete :destroy, :format => :json, :id => @published_page.id

      response.should be_success
      body = JSON.parse(response.body)
      body.should include('success')
      body.should include('redirect_to')
      body['redirect_to'].should eq(admin_pages_url)
    end

    it "should redirect to admin_pages_url for a normal request" do
      delete :destroy, :id => @published_page.id
        
      should redirect_to(admin_pages_url)
    end

  end  
end
