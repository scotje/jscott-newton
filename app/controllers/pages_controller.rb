class PagesController < ApplicationController
  caches_action :show

  def show
    @page = Page.published.find_by_slug(params[:slug])

    if @page.present?
      markdown = Redcarpet::Markdown.new(NewtonHtml5Renderer.new({:with_toc_data => true}), :no_intra_emphasis => true, :fenced_code_blocks => true, :autolink => true, :space_after_headers => true)
    
      @page.html = Redcarpet::Render::SmartyPants.render(markdown.render(@page.body))
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
