class Admin::BaseController < ApplicationController
  http_basic_authenticate_with :name => "admin", :password => "changeme"
  
  layout 'admin'
end
