class Post < ActiveRecord::Base
  attr_accessible :title, :slug, :post_type, :body
  
  attr_accessor :html

  validates :title, :slug, :post_type, :presence => true
  validates :body, :presence => { :message => "can't be blank for published posts" }, :if => "published_at.present?"
  validates :slug, :format => { :with => /^[a-z0-9\-]*$/, :message => "contains invalid characters for a post slug" }
  validates :post_type, :inclusion => { :in => %w(link prose picture video), :message => "is not a valid post type" }
  
  scope :draft, where('published_at IS NULL')
  scope :published, where('published_at IS NOT NULL')

  scope :published_in_year_and_month, lambda { |year, month| where("published_at IS NOT NULL AND published_at BETWEEN datetime('#{year}-#{"%02d" % month.to_i}-01 00:00:00') AND datetime('#{year}-#{"%02d" % month.to_i}-01 00:00:00','start of month','+1 month','-0.001 second')") }
  
  def published?
    self.published_at.present?
  end
end
