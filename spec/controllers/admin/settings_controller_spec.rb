require 'spec_helper'

describe Admin::SettingsController do
  include AdminHelper

  before(:each) do
    test_admin_login
  end
  
  describe Admin::SettingsController, 'index' do
    before(:each) do
      @system_settings = FactoryGirl.create_list(:setting, 5)
      @user_settings = FactoryGirl.create_list(:setting, 3, :user_setting)
    end
    
    context "basic response" do
      before(:each) do 
        get :index
      end

      it { should respond_with(:success) }
      it { should render_template(:index) }
    end
      
    it "should collect all the settings into @settings" do
      get :index
        
      assigns(:settings).should_not be_nil
      assigns(:settings).length.should eq(@system_settings.length + @user_settings.length)
    end
  end
  
  describe Admin::SettingsController, 'update' do
    before(:each) do
      @system_setting_to_update = FactoryGirl.create(:setting)
      @user_setting_to_update = FactoryGirl.create(:setting, :user_setting)
      
      @new_system_setting = FactoryGirl.build(:setting)
      @new_user_setting = FactoryGirl.build(:setting, :user_setting)
      
      @valid_updated_settings = {
        @system_setting_to_update.id => { 'value' => @new_system_setting.value },
        @user_setting_to_update.id => { 'value' => @new_user_setting.value },
      }
      
      @invalid_updated_settings = {
        @system_setting_to_update.id => { 'value' => '' },
        @user_setting_to_update.id => { 'value' => @new_user_setting.value },
      }
    end
    
    context "with valid attributes" do
      it "should update the values of the passed settings" do
        put :update, :settings => @valid_updated_settings
        
        @system_setting_to_update.reload
        @system_setting_to_update.value.should eq(@new_system_setting.value)

        @user_setting_to_update.reload
        @user_setting_to_update.value.should eq(@new_user_setting.value)
      end
      
      it "should redirect to admin_settings_url" do
        put :update, :settings => @valid_updated_settings
        
        should redirect_to(admin_settings_url)
      end
    end
    
    context "with invalid attributes" do
      it "should not alter the invalid setting attributes" do
        old_value = @system_setting_to_update.value

        put :update, :settings => @invalid_updated_settings
        
        @system_setting_to_update.reload
        @system_setting_to_update.value.should eq(old_value)
      end
      
      it "should update the valid setting attributes" do
        put :update, :settings => @invalid_updated_settings

        @user_setting_to_update.reload
        @user_setting_to_update.value.should eq(@new_user_setting.value)
      end
      
      it "should redirect to admin_settings_url" do
        put :update, :settings => @valid_updated_settings
        
        should redirect_to(admin_settings_url)
      end
    end
  end

  describe Admin::SettingsController, 'new' do
    context "basic response" do
      before(:each) do 
        get :new
      end

      it { should respond_with(:success) }
      it { should render_template(:new) }
    end

    it "should create a new Setting object" do
      get :new
      
      assigns(:setting).new_record?.should be_true
    end
    
    it "should allow an already instantiated Setting object in flash[:setting]" do
      setting = FactoryGirl.build(:setting, :user_setting)
      flash[:setting] = setting
      session[:flash] = flash
      
      get :new
      
      assigns(:setting).should eq(setting)
    end
  end
  
  describe Admin::SettingsController, 'create' do
    before(:each) do
      @valid_setting_attributes = FactoryGirl.attributes_for(:setting, :user_setting).delete_if { |key, value| [:system].include?(key) }
      @invalid_setting_attributes = FactoryGirl.attributes_for(:setting, :user_setting, :invalid_key).delete_if { |key, value| [:system].include?(key) }
    end
    
    it "should create a new user Setting object based on the passed parameters" do
      post :create, :setting => @valid_setting_attributes
      
      should assign_to(:setting)
      assigns(:setting).key.should eq(@valid_setting_attributes[:key])
      assigns(:setting).system.should be_false
    end
    
    context "with valid attributes" do
      it "should create a new Setting record" do
        expect {
          post :create, :setting => @valid_setting_attributes
        }.to change(Setting, :count).by(1)
      end
      
      it "should redirect to settings/index" do
        post :create, :setting => @valid_setting_attributes
        
        should redirect_to(admin_settings_url)
      end
    end
    
    context "with invalid attributes" do
      it "should not create a new Page record" do
        expect {
          post :create, :setting => @invalid_setting_attributes
        }.to_not change(Setting, :count)
      end

      it "should put the invalid @setting object into the flash" do
        post :create, :setting => @invalid_setting_attributes

        flash[:setting].should_not be_nil
        flash[:setting][:key].should eq(@invalid_setting_attributes[:key])
      end
      
      it "should redirect to new_admin_setting_url" do
        post :create, :setting => @invalid_setting_attributes

        should redirect_to(new_admin_setting_url)
      end
    end
  end
  
  describe Admin::SettingsController, 'destroy' do
    before(:each) do
      @system_setting = FactoryGirl.create(:setting)
      @user_setting = FactoryGirl.create(:setting, :user_setting)
    end
    
    it "should delete a given user setting" do
      expect {
        delete :destroy, :id => @user_setting.id
      }.to change(Setting, :count).by(-1)
    end

    it "should NOT delete a given system setting" do
      expect {
        delete :destroy, :id => @system_setting.id
      }.to_not change(Setting, :count)
    end

    it "should redirect to admin_pages_url for a normal request" do
      delete :destroy, :id => @user_setting.id
        
      should redirect_to(admin_settings_url)
    end

  end  
end
