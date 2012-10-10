class Admin::BaseController < ApplicationController
  before_filter :authenticate
  
  layout 'admin'
  

  protected
  # --------------------------
  
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      if Rails.env.test?
        # Leave these alone, they are only valid in the 'test' environment so the admin controllers can be tested.
        name == 'test_admin' && password == 'potato_topiary'
      else
        # Change this to whatever you want.
        name == 'admin' && password == 'changeme'
      end
    end
  end
end
