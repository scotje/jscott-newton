require 'spec_helper'

describe Page do
  describe "accessibility" do
    it { should allow_mass_assignment_of(:title) }
    it { should allow_mass_assignment_of(:slug) }
    it { should allow_mass_assignment_of(:body) }
    it { should allow_mass_assignment_of(:published_at) }
    
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end
  
  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:slug) }
    
    it "should allow slug with a valid format" do
      page = FactoryGirl.build(:page, :draft)
      page.slug = 'this-is-a-valid-slug'
      page.should be_valid
    end
    
    it "should reject slug with an invalid format" do
      should validate_format_of(:slug).not_with('Invalid Slug With Spaces!').with_message(/contains invalid characters for a page slug/)
    end
    
    it "should validate uniqueness of page slug" do
      page = FactoryGirl.create(:page, :draft)
      
      should validate_uniqueness_of(:slug)
    end
    
    context "published page" do
      subject do
        FactoryGirl.create(:page, :published)
      end
      
      it { should validate_presence_of(:body).with_message(/can't be blank for published pages/) }
    end
  end
  
  describe "scopes" do
    before(:each) do
      @published_pages = FactoryGirl.create_list(:page, 5, :published)
      @draft_pages = FactoryGirl.create_list(:page, 3, :draft)
    end
    
    describe ".published" do
      before(:each) do
        @results = Page.published.all
      end
      
      it "should collect the correct number of pages" do
        @results.length.should eq(@published_pages.length)
      end
      
      it "should return an array of pages" do
        @results.should be_an(Array)
        
        @results.each do |p|
          p.should be_an(Page)
        end
      end
      
      it "should not include any draft pages" do
        @results.each do |p|
          p.published_at.should_not be_nil
        end
      end
    end
    
    describe ".draft" do
      before(:each) do
        @results = Page.draft.all
      end
      
      it "should collect the correct number of pages" do
        @results.length.should eq(@draft_pages.length)
      end
      
      it "should return an array of pages" do
        @results.should be_an(Array)

        @results.each do |p|
          p.should be_an(Page)
        end
      end
      
      it "should not include any published pages" do
        @results.each do |p|
          p.published_at.should be_nil
        end
      end
    end
  end
  
  describe ".published?" do
    before(:each) do
      @page = FactoryGirl.create(:page, :published)
      @draft = FactoryGirl.create(:page, :draft)
    end
    
    it "should return true for a published page" do
      @page.published?.should be_true
    end
    
    it "should return false for a draft page" do
      @draft.published?.should be_false
    end
  end
end
