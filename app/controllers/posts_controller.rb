class PostsController < ApplicationController
  caches_page :index, :show
  
  def index
    @posts = Post.published.order('published_at DESC').limit(10)
  end
  
  def list
    if params[:year].present? && params[:month].present?
      @title = "Posts by Month: #{Time.local(params[:year], params[:month]).strftime('%B %Y')}"
      @posts = Post.published.where(["published_at BETWEEN ? AND ?", Time.local(params[:year], params[:month]), Time.local(params[:year], params[:month]).end_of_month]).order('published_at DESC')
    elsif params[:tag].present?
      # to be implemented
    elsif params[:type].present?
      @title = "Posts by Type: #{params[:type].capitalize}"
      @posts = Post.published.where({ :post_type => params[:type] }).order('published_at DESC').limit(10)
    else
      redirect_to :action => 'index' and return
    end
  end
  
  def show
    if params[:slug].present?
      @post = Post.published_in_year_and_month(params[:year], params[:month]).where({ :slug => params[:slug] }).first
    end

    if @post.present?
      if params[:month].length == 1
        redirect_to(post_url(:year => @post.published_at.year, :month => @post.published_at.month.to_s.rjust(2, '0'), :slug => @post.slug), :status => :moved_permanently) and return
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
