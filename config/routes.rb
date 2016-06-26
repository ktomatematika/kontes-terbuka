Rails.application.routes.draw do
  resources :province do
    resources :users
  end

  resources :status do
    resources :users
  end

  resources :users
  resources :roles
  resources :contests do
    get 'show_rules' => 'contests#show_rules', on: :member, as: :show_rules
    post 'accept_rules' => 'contests#accept_rules', on: :collection,
         as: :accept_rules
    resources :short_problems
    resources :long_problems
  end

  resources :short_problems do
    resources :short_submissions
  end

  resources :long_problems do
    resources :long_submissions
  end

  resources :short_submissions
  resources :long_submissions
  resources :user_contests
  root 'welcome#index'

  get '/sign' => 'welcome#sign'
  get '/register' => 'users#new'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy', as: :logout
  delete '/logout' => 'sessions#destroy'

  get '/contests/:id/rules' => 'contests#rules'

  get '/home/index' => 'home#index'
  get '/faq' => 'home#faq'
  get '/book' => 'home#book'
  get '/donate' => 'home#donate'
  get '/about' => 'home#about'
  get '/privacy' => 'home#privacy'
  get '/terms' => 'home#terms'
  get '/contact' => 'home#contact'

  post '/short_problems/submit' => 'short_problems#submit'
  post '/long_problems/submit' => 'long_problems#submit'

  get '/magic' => 'home#send_magic_email', as: :magic

  post '/check' => 'users#check_unique'
end
