# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

# Settings
FactoryGirl.create(:setting, :key => 'admin.user', :setting_type => 'string', :value => 'admin')
FactoryGirl.create(:setting, :key => 'admin.password', :setting_type => 'string', :value => 'changeme')
FactoryGirl.create(:setting, :key => 'blog.title', :setting_type => 'string', :value => 'default newton blog')
FactoryGirl.create(:setting, :key => 'blog.copyright_holder', :setting_type => 'string', :value => 'Joe Sixpack')
