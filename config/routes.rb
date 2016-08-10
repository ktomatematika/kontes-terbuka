Rails.application.routes.draw do
  root 'welcome#index'

  match '*path', to: 'application#maintenance', via: :all

  resources :users do
    post 'mini-update', to: 'users#mini_update'
    get 'change-password', to: 'users#change_password'
    post 'change-password', to: 'users#process_change_password'
    get 'change-notifications', to: 'users#change_notifications'
    post 'change-notifications', to: 'users#process_change_notifications',
                                 as: 'process_change_notifications'
  end

  get '/sign', to: 'welcome#sign'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  post '/forgot', to: 'users#process_forgot_password'

  post '/check', to: 'users#check_unique'
  get '/verify/:verification', to: 'users#verify', as: :verify
  get 'reset-password/:verification', to: 'users#reset_password',
                                      as: 'reset_password'
  post 'reset-password', to: 'users#process_reset_password',
                         as: 'process_reset_password'

  resources :contests do
    get 'admin', to: 'contests#admin'
    get 'rules', to: 'contests#show_rules'
    post 'rules', to: 'contests#accept_rules'
    get 'feedback', to: 'contests#give_feedback'
    post 'feedback', to: 'contests#feedback_submit'
    get 'download', to: 'contests#download_feedback'
    get 'summary', to: 'contests#summary'

    resources :short_problems, path: '/short-problems'
    post 'create-short-submissions', to: 'contests#create_short_submissions'
    resources :long_problems, path: '/long-problems'

    resources :long_submissions, path: '/long-submissions' do
      post 'submit', to: 'long_submissions#submit'
      delete 'destroy_subs', to: 'long_submissions#destroy_submissions'
      get 'download', to: 'long_submissions#download'
    end

    resources :feedback_questions, path: '/feedback-questions'

    post 'give-points', to: 'contests#give_points'

    get 'pdf', to: 'contests#download_pdf'
    get 'ms-pdf', to: 'contests#download_marking_scheme'

    post 'read-problems', to: 'contests#read_problems'
  end

  get '/download-submissions/:id', to: 'long_problems#download',
                                   as: 'download_submissions'
  get '/autofill-marks/:id', to: 'long_problems#autofill', as: 'autofill_marks'
  post '/upload-report/:id', to: 'long_problems#upload_report',
                             as: 'upload_report'

  # resources :market_items, path: '/market-items'

  get '/mark-solo/:id', to: 'long_problems#mark_solo', as: :mark_solo
  post '/submit-temporary-markings/:id',
       to: 'long_problems#submit_temporary_markings',
       as: :submit_temporary_markings
  post '/submit-final-markings/:id',
       to: 'long_problems#submit_final_markings', as: :submit_final_markings
  get '/mark-final/:id', to: 'long_problems#mark_final', as: :mark_final

  get '/home', to: 'home#index'
  get '/faq', to: 'home#faq'
  get '/book', to: 'home#book'
  get '/donate', to: 'home#donate'
  get '/about', to: 'home#about'
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/contact', to: 'home#contact'
  get '/penguasa', to: 'home#admin', as: :admin

  get '/assign/:id', to: 'contests#assign_markers', as: :assign_markers
  post 'create-marker', to: 'roles#create_marker'
  delete 'remove-marker', to: 'roles#remove_marker'

  post '/line-bot', to: 'line#callback'

  match '*path', to: 'errors#error_4xx', via: :all
end
