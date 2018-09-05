Rails.application.routes.draw do
  root 'instant_search#index'
  post 'instant_search/create', to: 'instant_search#create'
  get 'analytics/index', to: 'analytics#index'
  delete 'analytics/destroy', to: 'analytics#destroy' 
  delete 'analytics/destroy_record', to: 'analytics#destroy_record' 
  get 'articles/index', to: 'articles#index'
  post 'articles/create', to: 'articles#create'
  delete 'articles/destroy', to: 'articles#destroy'
  delete 'articles/destroy_article', to: 'articles#destroy_article'  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
