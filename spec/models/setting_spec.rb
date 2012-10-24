require 'spec_helper'

describe Setting do
  describe "accessibility" do
    it { should allow_mass_assignment_of(:key) }
    it { should allow_mass_assignment_of(:setting_type) }
    it { should allow_mass_assignment_of(:value) }
    
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:system) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:setting_type) }
    
    it "should validate uniqueness of setting key" do
      setting = FactoryGirl.create(:setting)
      
      should validate_uniqueness_of(:key)
    end
    
    it "should reject an invalid setting key" do
      setting = FactoryGirl.build(:setting, :invalid_key)
      
      setting.should_not be_valid
    end
    
    it "should accept a valid setting key" do
      setting = FactoryGirl.build(:setting)
      
      setting.should be_valid
    end
    
    it "should require a value for a system setting" do
      setting = FactoryGirl.build(:setting, :value => '')
      
      setting.should_not be_valid
    end
    
    it "should not require a value for a user setting" do
      setting = FactoryGirl.build(:setting, :user_setting, :value => '')
      
      setting.should be_valid
    end
  end
  
  describe "scopes" do
    before(:each) do
      @system_settings = FactoryGirl.create_list(:setting, 5)
      @user_settings = FactoryGirl.create_list(:setting, 3, :user_setting)
    end
    
    describe ".system_only" do
      before(:each) do
        @results = Setting.system_only.all
      end
      
      it "should collect the correct number of system settings" do
        @results.length.should eq(@system_settings.length)
      end
      
      it "should return an array of settings" do
        @results.should be_an(Array)

        @results.each do |s|
          s.should be_an(Setting)
        end
      end
      
      it "should not include any user settings" do
        @results.each do |s|
          s.system.should eq(true)
        end
      end
    end
    
    describe ".user_only" do
      before(:each) do
        @results = Setting.user_only.all
      end
      
      it "should collect the correct number of user settings" do
        @results.length.should eq(@user_settings.length)
      end
      
      it "should return an array of settings" do
        @results.should be_an(Array)

        @results.each do |s|
          s.should be_an(Setting)
        end
      end
      
      it "should not include any system settings" do
        @results.each do |s|
          s.system.should eq(false)
        end
      end
    end
  end
end
