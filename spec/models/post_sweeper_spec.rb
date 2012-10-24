require 'spec_helper'

# This test can only really verify that the sweeper/observer is receiving the appropriate 
# callbacks. The actual caching and clearing functionality is tested in request specs.

describe PostSweeper do
  subject { PostSweeper.instance }

  it 'should be notified when a post is created' do
    subject.should_receive(:after_create)

    Post.observers.enable :post_sweeper do
      FactoryGirl.create(:post)
    end
  end
  
  it 'should be notified when a post is updated' do
    @post = FactoryGirl.create(:post)

    subject.should_receive(:after_update)

    Post.observers.enable :post_sweeper do
      @post.published_at = Time.new
      @post.save
    end
  end
  
  it 'should be notified when a post is destroyed' do
    @post = FactoryGirl.create(:post)
    
    subject.should_receive(:after_destroy)

    Post.observers.enable :post_sweeper do
      @post.destroy
    end
  end
end
