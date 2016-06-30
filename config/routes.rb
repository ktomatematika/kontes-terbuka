Rails.application.routes.draw do
  root 'welcome#index'

  resources :users
  resources :contests do
    get 'admin', to: 'contests#admin'
    get 'show_rules', to: 'contests#show_rules'
    post 'accept_rules', to: 'contests#accept_rules', on: :collection

    resources :short_problems
    resources :long_problems
  end

  get '/mark_solo/:id', to: 'long_problems#mark_solo', as: :mark_solo
  get '/mark_final/:id', to: 'long_problems#mark_final', as: :mark_final

  get '/sign', to: 'welcome#sign'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'

  get '/home/index', to: 'home#index'
  get '/faq', to: 'home#faq'
  get '/book', to: 'home#book'
  get '/donate', to: 'home#donate'
  get '/about', to: 'home#about'
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/contact', to: 'home#contact'
  get '/admin', to: 'home#admin'

  post '/short_problems/submit', to: 'short_problems#submit'
  post '/long_problems/submit', to: 'long_problems#submit'

  get '/magic', to: 'home#send_magic_email', as: :magic

  post '/check', to: 'users#check_unique'

  get '/assign/:id', to: 'roles#assign_markers'
end
