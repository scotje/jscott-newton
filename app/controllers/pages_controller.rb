class PagesController < ApplicationController
  caches_page :show

  def show
    @page = Page.published.find_by_slug(params[:slug])

    if @page.blank?
      raise ActiveRecord::RecordNotFound
    end
  end
end
