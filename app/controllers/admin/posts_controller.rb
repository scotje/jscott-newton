class Admin::PostsController < Admin::BaseController
  before_filter :is_request_for_drafts?
  cache_sweeper :post_sweeper, :only => [ :create, :update, :destroy ]

  def index
    if @for_drafts
      @posts = Post.draft.order('title ASC')
    else
      @posts = Post.published.order('published_at DESC')
    end
  end
  
  def new
    if flash[:post].present?
      @post = flash[:post]
    else
      @post = Post.new
    end
    
    @autosave_url = nil
  end
  
  def create
    @post = Post.new(params[:post])
    
    if params[:resource_action] == 'publish'
      @post.published_at = Time.new
    end
    
    if @post.save
      if @post.published?
        redirect_to admin_posts_url
      else
        redirect_to admin_drafts_url
      end
    else
      @post.published_at = nil
      flash[:post] = @post

      redirect_to new_admin_draft_url
    end
  end
  
  def edit
    @post = Post.find(params[:id])
    
    if @post.published?
      @autosave_url = nil
    else
      @autosave_url = admin_draft_url(@post)
    end
  end
  
  def _preview
    post = Post.new(:body => params[:body])
    render :json => { :html => post.html }
  end
  
  def update
    @post = Post.find(params[:id])
    @post.update_attributes(params[:post])
    
    if params[:resource_action] == 'publish'
      @post.published_at = Time.new
    elsif params[:resource_action] == 'unpublish'
      @post.published_at = nil
    end
    
    if @post.save
      respond_to do |format|
        format.html do
          if @post.published?
            redirect_to admin_posts_url
          else
            redirect_to admin_drafts_url
          end
        end

        format.json  { render :json => { :success => true } }
      end
    else
      @post.published_at = @post.published_at_was if @post.published_at_changed?
      flash[:post] = @post
      
      if @post.published?
        redirect_to edit_admin_post_url(@post)
      else
        redirect_to edit_admin_draft_url(@post)
      end
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    
    @post.destroy
    
    if @post.published?
      destination = admin_posts_url
    else
      destination = admin_drafts_url
    end
    
    respond_to do |format|
      format.html { redirect_to destination }
      format.json { render :json => { :success => true, :redirect_to => destination } }
    end
  end
  
  private
  
  def is_request_for_drafts?
    @for_drafts = params[:draft].present?
    
    return @for_drafts
  end
end
