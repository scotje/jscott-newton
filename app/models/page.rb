class Page < ActiveRecord::Base
  attr_accessible :title, :slug, :published_at, :body
  
  attr_accessor :html

  validates :title, :slug, :presence => true
  validates :body, :presence => { :message => "can't be blank for published pages" }, :if => "published_at.present?"
  validates :slug, :format => { :with => /^[a-z0-9\-]*$/, :message => "contains invalid characters for a page slug" }
  validates :slug, :uniqueness => true
  
  scope :draft, where('published_at IS NULL')
  scope :published, where('published_at IS NOT NULL')

  def published?
    self.published_at.present?
  end
end
