Rails.application.routes.draw do


  root "itasks#index"

  resources :itasks, only:[:index] do
    collection do
      get 'search'
      post 'preview'
    end

  end
  resources :categories 
  resources :tasks do
    member do
      post 'star'
      post 'take'
      post 'finish'
      post 'agree'
    end
    resources :comments
  end

  get 'register' => 'users#register'
  get 'login' => 'users#login'
  get 'logout' => 'users#logout'
  resources :users do
    collection do
      get 'set'
      post 'set_userinfo'
      get 'change_password'
      post 'update_password'
      post 'upload_img'
      get 'register'
      post 'register_confirm'
      get 'login'
      post 'login_confirm'
      get 'logout'
      get 'send_active_mail'
      get 'activation'
      get 'forget_password'
      post 'forget_password_confirm'
      get 'change_pw'
      post 'change_pw_confirm'
      # get 'create_task'
    end
  end

end
