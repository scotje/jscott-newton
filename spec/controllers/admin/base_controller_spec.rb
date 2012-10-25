require 'spec_helper'

describe Admin::BaseController do
  include AdminHelper
  
  controller(Admin::BaseController) do
    def index
      render :text => 'foo'
    end
  end
  
  before(:each) do
    @blog_title_setting = FactoryGirl.create(:setting, :key => 'blog.title')
  end

  describe ".load_settings" do
    before(:each) do
      FactoryGirl.create_list(:setting, 5)
      FactoryGirl.create_list(:setting, 3, :user_setting)

      test_admin_login
      
      get :index
    end
    
    it { should assign_to(:_settings) }
    
    it "should assign the correct number of system settings" do
      assigns(:_settings)[:system].length.should eq(6)
    end

    it "should assign the correct number of user settings" do
      assigns(:_settings)[:user].length.should eq(3)
    end
  end
  
  describe ".authenticate" do
    context "in test environment" do
      it "should respond with success when given test credentials" do
        test_admin_login
        
        get :index
        
        should respond_with(:success)
      end
      
      it "should respond with status 401 when not given credentials" do
        get :index
        
        should respond_with(401)
      end

      it "should respond with status 401 when given invalid credentials" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'wrong')

        get :index
        
        should respond_with(401)
      end
    end
    
    context "in non-test environment" do
      before(:each) do
        Rails.env = 'development'
      end
      
      after(:each) do
        Rails.env = 'test'
      end
      
      context "when admin user and password settings exist" do
        before(:each) do
          @admin_username = FactoryGirl.create(:setting, :key => 'admin.user')
          @admin_password = FactoryGirl.create(:setting, :key => 'admin.password')
        end
        
        it "should respond with success when given valid credentials" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@admin_username.value, @admin_password.value)
          
          get :index
          
          should respond_with(:success)
        end
      
        it "should respond with status 401 when not given credentials" do
          get :index
          
          should respond_with(401)
        end

        it "should respond with status 401 when given invalid credentials" do
          request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'wrong')

          get :index
          
          should respond_with(401)
        end
      end
      
      context "when admin user and password settings do not exist" do
        it "should respond with status 401" do
          get :index
          
          should respond_with(401)
        end
      end
    end
  end

  describe ".set_blog_title" do
    context "in non-test environment" do
      before(:each) do
        ::Rails.env = 'development'
      end
      
      after(:each) do
        ::Rails.env = 'test'
      end
      
      context "with a title setting present" do
        it "should set @blog_title" do
          get :index
      
          should assign_to(:blog_title)
        end
    
        it "should set @blog_title to setting value" do
          get :index

          assigns(:blog_title).should eq(@blog_title_setting.value)
        end
      end
      
      context "without a title setting present" do
        before(:each) do
          @blog_title_setting.destroy
        end
        
        it "should raise an exception" do
          lambda {
            get :index
          }.should raise_error StandardError
        end
      end
    end

    it "should set @blog_title" do
      get :index
      
      should assign_to(:blog_title)
    end
    
    it "should set @blog_title to 'test blog'" do
      get :index

      assigns(:blog_title).should eq('test blog')
    end
  end

end