Pdxspurs::Application.routes.draw do

  resources :lists, :posts, :users, :user_sessions, :password_resets

  root :to =>           'main#index'
  
  get    'login' =>     'user_sessions#new',     :as => :login
  get    'logoff' =>    'user_sessions#logoff',  :as => :logoff
  delete 'logout' =>    'user_sessions#destroy', :as => :logout

  post   'upload/uploadfile' => "upload#uploadfile"  
  get    'upload'            => "upload#index"  

  post 'password_resets/new'    => "password_resets#new"
  put  'password_resets/new'    => "password_resets#new"
  put  'password_resets/update' => "password_resets#update"

end


