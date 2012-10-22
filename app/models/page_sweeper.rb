class PageSweeper < ActionController::Caching::Sweeper
  observe Page
 
  # If our sweeper detects that a Page was updated call this
  def after_update(page)
    if page.published? || (page.published_at_changed? && page.published_at_was.present?) # If the Page is published or WAS published.
      expire_cache_for(page)
    end
  end
 
  # If our sweeper detects that a Page was deleted call this
  def after_destroy(page)
    if page.published?
      expire_cache_for(page)
    end
  end
 
  private
  
  def expire_cache_for(page)
    cached_slug = page.slug_changed? ? page.slug_was : page.slug

    expire_page(:controller => '/pages', :action => :show, :slug => cached_slug)
  end
end