Rails.application.routes.draw do
  root 'welcome#index'

  resources :users do
    post 'mini_update', to: 'users#mini_update'
    get 'change_password', to: 'users#change_password'
    post 'change_password', to: 'users#process_change_password'
  end

  get '/sign', to: 'welcome#sign'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  post '/forgot', to: 'users#process_forgot_password'

  post '/check', to: 'users#check_unique'
  get '/verify/:verification', to: 'users#verify'
  get 'reset_password/:verification', to: 'users#reset_password'
  post 'reset_password/:verification', to: 'users#process_reset_password'

  resources :contests do
    get 'admin', to: 'contests#admin'
    get 'show_rules', to: 'contests#show_rules'
    post 'accept_rules', to: 'contests#accept_rules', on: :collection
    get 'feedback', to: 'contests#give_feedback'
    post 'feedback', to: 'contests#feedback_submit'
    get 'download', to: 'contests#download_feedback'

    resources :short_problems
    post 'create_short_submissions', to: 'contests#create_short_submissions'
    resources :long_problems

    resources :feedback_questions

    get 'give_points', to: 'contests#give_points'
  end

  #resources :market_items

  get '/mark_solo/:id', to: 'long_problems#mark_solo', as: :mark_solo
  get '/mark_final/:id', to: 'long_problems#mark_final', as: :mark_final

  get '/home', to: 'home#index'
  get '/faq', to: 'home#faq'
  get '/book', to: 'home#book'
  get '/donate', to: 'home#donate'
  get '/about', to: 'home#about'
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/contact', to: 'home#contact'
  get '/penguasa', to: 'home#admin', as: :admin

  resources :long_submissions do
    post 'submit' => 'long_submissions#submit', on: :member
  end

  get '/assign/:id', to: 'contests#assign_markers', as: :assign_markers
  post 'create_marker', to: 'roles#create_marker'
  delete 'remove_marker', to: 'roles#remove_marker'
end
