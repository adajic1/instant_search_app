Rails.application.routes.draw do
  post 'instant_search/create', to: 'instant_search#create'
  root 'instant_search#index'
    
  get 'analytics/index', to: 'analytics#index'
  delete 'analytics/destroy', to: 'analytics#destroy' 
  delete 'analytics/destroy_record', to: 'analytics#destroy_record' 
  
  post 'articles/create', to: 'articles#create'
  get 'articles/index', to: 'articles#index'
  delete 'articles/destroy', to: 'articles#destroy'
  delete 'articles/destroy_article', to: 'articles#destroy_article'  
  
  post 'user_action/create', to: 'user_action#create'
  get 'user_action/index', to: 'user_action#index'
  delete 'user_action/destroy_session', to: 'user_action#destroy_session'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
