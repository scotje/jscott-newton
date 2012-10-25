class ApplicationController < ActionController::Base
  protect_from_forgery
  
  prepend_before_filter :load_settings
  before_filter :set_blog_title
  
  prepend_view_path 'app/views/_custom'
  
  protected
  
  def load_settings
    @settings = parse_settings
  end
  
  def set_blog_title
    if Rails.env.test?
      @blog_title = "test blog"
    else
      begin
        @blog_title = @settings[:system][:blog][:title]
      rescue
        raise "You need to seed your database! Run \"rake db:seed\" from the application's root folder."
      end
    end
  end

  def parse_settings
    settings = { }
    
    Setting.all.each do |s|
      if s.system
        s.key = "system.#{s.key}"
      else
        s.key = "user.#{s.key}"
      end

      # I'll unpack this a little for future reference:
      #  - deep_merge! is a recursive hash merge provided by ActiveSupport::CoreExtensions::Hash
      #  - setting keys are split on periods and each key segment will eventually become its own hash in the result
      #  - reversing the array of key segments means we will start our inject/reduce operation with the deepest segment
      #  - the inject starts an accumulator with the setting value
      #  - the block returns a new hash with the current symbolized key segment assigned to the current value of the accumulator
      #  - as it unwinds itself it builds the whole hash for the current setting which is then merged into the overall settings hash
      settings.deep_merge!(s.key.split('.').reverse.inject(s.value) { |a, n| { n.to_sym => a } })
    end
    
    return settings
  end
end
