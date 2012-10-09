class Setting < ActiveRecord::Base
  attr_accessible :key, :setting_type, :value
  
  validates :key, :setting_type, :presence => true
  validates :key, :uniqueness => true
  
  scope :system, where({ :system => true })
  scope :user, where({ :system => false })
end
