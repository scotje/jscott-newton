class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_blog_title
  
  
  private
  
  def set_blog_title 
    @blog_title = "default newton blog"
  end
end
