Pdxspurs::Application.routes.draw do

  resources :lists, :posts, :users, :user_sessions, :password_resets

  root :to =>           'main#index'
  
  get    'login' =>     'user_sessions#new',     :as => :login
  delete 'logout' =>    'user_sessions#destroy', :as => :logout

end


