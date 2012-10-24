class PostSweeper < ActionController::Caching::Sweeper
  observe Post
 
  # If our sweeper detects that a Post was created call this
  def after_create(post)
    if post.published?
      expire_post_index_cache
    end
  end
 
  # If our sweeper detects that a Post was updated call this
  def after_update(post)
    if post.published? || (post.published_at_changed? && post.published_at_was.present?) # If the Post is published or WAS published.
      expire_cache_for(post)
    end
  end
 
  # If our sweeper detects that a Post was deleted call this
  def after_destroy(post)
    if post.published?
      expire_cache_for(post)
    end
  end
 
  private
  
  def expire_post_index_cache
    expire_page(:controller => '/posts', :action => 'index')
  end
  
  def expire_cache_for(post)
    expire_post_index_cache

    cached_published_at = post.published_at_changed? ? post.published_at_was : post.published_at
    cached_slug = post.slug_changed? ? post.slug_was : post.slug

    if cached_published_at.present?
      expire_page(:controller => '/posts', :action => :show, :year => cached_published_at.year, :month => cached_published_at.month.to_s.rjust(2, '0'), :slug => cached_slug)
    end
  end
end