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
        # Default username is 'admin' and default password is 'changeme'.
        name == @_settings[:system][:admin][:user] && password == @_settings[:system][:admin][:password]
      end
    end
  end
  
  def load_settings
    # In the admin area, current settings are in @_settings so that they don't get stomped in the Admin::Settings controller.
    @_settings = parse_settings
  end
end
