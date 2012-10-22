class Admin::PagesController < Admin::BaseController
  cache_sweeper :page_sweeper, :only => [ :update, :destroy ]

  def index
    @pages = Page.order('title ASC')
  end
  
  def new
    if flash[:page].present?
      @page = flash[:page]
    else
      @page = Page.new
    end
    
    @autosave_url = nil
  end
  
  def create
    @page = Page.new(params[:page])
    
    if params[:resource_action] == 'publish'
      @page.published_at = Time.new
    end
    
    if @page.save
      redirect_to admin_pages_url
    else
      @page.published_at = nil
      flash[:page] = @page

      redirect_to new_admin_page_url
    end
  end
  
  def edit
    @page = Page.find(params[:id])
    
    if @page.published?
      @autosave_url = nil
    else
      @autosave_url = admin_page_url(@page)
    end
  end
  
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    
    if params[:resource_action] == 'publish'
      @page.published_at = Time.new
    elsif params[:resource_action] == 'unpublish'
      @page.published_at = nil
    end
    
    if @page.save
      respond_to do |format|
        format.html { redirect_to admin_pages_url }
        format.json { render :json => { :success => true } }
      end
    else
      @page.published_at = @page.published_at_was if @page.published_at_changed?
      flash[:page] = @page

      redirect_to edit_admin_page_url(@page)
    end
  end
  
  def destroy
    Page.destroy(params[:id])
    
    respond_to do |format|
      format.html { redirect_to admin_pages_url }
      format.json { render :json => { :success => true, :redirect_to => admin_pages_url } }
    end
  end
end
