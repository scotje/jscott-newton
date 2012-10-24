class Setting < ActiveRecord::Base
  attr_accessible :key, :setting_type, :value
  
  validates :key, :setting_type, :presence => true
  validates :key, :uniqueness => true
  validates :key, :format => { :with => /\A[a-z0-9\.\_\-]+\z/, :message => "'%{value}' contains invalid characters" }

  validates :value, :presence => { :message => 'cannot be blank for system settings' }, :if => "system == true"
  
  scope :system_only, where({ :system => true })
  scope :user_only, where({ :system => false })
end
