require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      render :text => 'foo'
    end
  end
    
  describe ".load_settings" do
    before(:each) do
      FactoryGirl.create_list(:setting, 5)
      FactoryGirl.create_list(:setting, 3, :user_setting)
      
      get :index
    end
    
    it { should assign_to(:settings) }
    
    it "should assign the correct number of system settings" do
      assigns(:settings)[:system].length.should eq(5)
    end

    it "should assign the correct number of user settings" do
      assigns(:settings)[:user].length.should eq(3)
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
        before(:each) do
          @title_setting = FactoryGirl.create(:setting, :key => 'blog.title')
        end

        it "should set @blog_title" do
          get :index
      
          should assign_to(:blog_title)
        end
    
        it "should set @blog_title to setting value" do
          get :index

          assigns(:blog_title).should eq(@title_setting.value)
        end
      end
      
      context "without a title setting present" do
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
