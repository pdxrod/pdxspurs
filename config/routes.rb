Pdxspurs::Application.routes.draw do

  resources :lists, :posts, :users, :user_sessions, :password_resets

  root :to =>           'main#index'
  
  get    'login' =>     'user_sessions#new',     :as => :login
  get    'logout' =>    'user_sessions#destroy', :as => :logout
  delete 'logout' =>    'user_sessions#destroy', :as => :logout

  post   'upload/uploadfile' => "upload#uploadfile"  
  get    'upload'            => "upload#index"  

end


