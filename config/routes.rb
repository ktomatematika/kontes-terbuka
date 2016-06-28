Rails.application.routes.draw do
  root 'welcome#index'

  resources :users
  resources :roles
  resources :contests do
    get 'show_rules' => 'contests#show_rules', on: :member
    get 'mark_solo/:problem_no' => 'long_problems#mark_solo', on: :member
    get 'mark_final/:problem_no' => 'long_problems#mark_final', on: :member
    post 'accept_rules' => 'contests#accept_rules', on: :collection
    resources :short_problems
    resources :long_problems
  end

  get '/sign' => 'welcome#sign'
  get '/register' => 'users#new'
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  delete '/logout' => 'sessions#destroy'

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
