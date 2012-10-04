module Admin::BaseHelper
  
  def post_types
    [
      ['Link', 'link'],
      ['Prose', 'prose'],
      ['Picture', 'picture'],
      ['Video', 'video']
    ]
  end
  
end
