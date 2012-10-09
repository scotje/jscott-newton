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
    
    it "should validate uniquness of setting key" do
      setting = FactoryGirl.create(:setting)
      
      should validate_uniqueness_of(:key)
    end
  end
  
  describe "scopes" do
    before(:each) do
      @system_settings = FactoryGirl.create_list(:setting, 5)
      @user_settings = FactoryGirl.create_list(:user_setting, 3)
    end
    
    describe ".system" do
      before(:each) do
        @results = Setting.system.all
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
    
    describe ".user" do
      before(:each) do
        @results = Setting.user.all
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
