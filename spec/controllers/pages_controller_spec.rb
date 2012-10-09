require 'spec_helper'

describe PagesController do
  before(:each) do
    @page = FactoryGirl.create(:page)
    @draft_page = FactoryGirl.create(:draft_page)
  end
  
  describe PagesController, '#show' do
    context "for a published page" do
      before(:each) do
        get :show, :slug => @page.slug
      end
      
      it { should respond_with(:success) }
      it { should assign_to(:page) }
      it { should render_template(:show) }
    end
    
    context "for an unpublished page" do
      it "should raise a RecordNotFound exception" do
        expect {
          get :show, :slug => @draft_page.slug
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
