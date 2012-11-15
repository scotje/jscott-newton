Newton::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  namespace :admin do 
    resources :posts do
      post '_preview', :on => :collection, :as => 'preview'
    end  

    resources :drafts, :controller => "posts", :draft => true
    
    resources :pages do
      post '_preview', :on => :collection, :as => 'preview'
    end
    
    resources :comments
    resources :settings, :except => [ :show, :edit, :update ] do
      put 'update', :on => :collection
    end

    root :to => 'posts#index'
  end

  match ':year/:month/:slug' => 'posts#show', :year => /2\d{3}/, :month => /\d{1,2}/, :as => 'post'
  match '/pages/:slug' => 'pages#show', :as => 'page'
  match '/archives/:year/:month' => 'posts#list', :year => /2\d{3}/, :month => /\d{2}/, :as => 'archives_by_month'
  match '/archives/tag/:tag' => 'posts#list', :as => 'archives_by_tag'
  match '/archives/:type' => 'posts#list', :as => 'archives_by_type', :type => /\w*/

  root :to => 'posts#index'
end
