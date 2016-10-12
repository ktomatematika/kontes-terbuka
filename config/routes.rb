Rails.application.routes.draw do
  root 'welcome#index'

  resources :users do
    member do
      post 'mini-update', to: 'users#mini_update'
      get 'change-password', to: 'users#change_password'
      post 'change-password', to: 'users#process_change_password'
      get 'change-notifications', to: 'users#change_notifications'
      post 'change-notifications', to: 'users#process_change_notifications',
                                   as: 'process_change_notifications'
    end

    collection do
      get 'sign', to: 'welcome#sign'
      get 'register', to: 'users#new'
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'forgot', to: 'users#process_forgot_password'

      post 'check', to: 'users#check_unique'
      get 'verify/:verification', to: 'users#verify', as: :verify
      get 'reset-password/:verification', to: 'users#reset_password',
                                          as: 'reset_password'
      post 'reset-password', to: 'users#process_reset_password',
                             as: 'process_reset_password'
    end
  end

  resources :contests do
    member do
      get 'admin', to: 'contests#admin'
      post 'copy-feedback-questions', to: 'feedback_questions#copy'
      delete 'destroy-short-probs', to: 'contests#destroy_short_probs'
      delete 'destroy-long-probs', to: 'contests#destroy_long_probs'
      delete 'destroy-feedback_qns', to: 'contests#destroy_feedback_qns'

      get 'summary', to: 'contests#summary'

      post 'read-problems', to: 'contests#read_problems'
      get 'assign', to: 'contests#assign_markers'

      get 'rules', to: 'contests#show_rules'
      post 'rules', to: 'contests#accept_rules'

      get 'feedback', to: 'contests#give_feedback'
      post 'feedback', to: 'contests#feedback_submit'
      get 'download-feedback', to: 'contests#download_feedback',
                               defaults: { format: 'csv' }

      get 'download-results', to: 'contests#download_results',
                              defaults: { format: 'pdf' }

      post 'create-short-submissions', to: 'contests#create_short_submissions'

      get 'pdf', to: 'contests#download_pdf'
      get 'ms-pdf', to: 'contests#download_marking_scheme'
    end

    resources :short_problems, path: '/short-problems'
    resources :long_problems, path: '/long-problems' do
      post 'marker', to: 'roles#create_marker'
      delete 'marker', to: 'roles#remove_marker'
      get 'download-submissions/:id', to: 'long_problems#download',
                                       as: 'download_submissions'
      post 'autofill-marks/:id', to: 'long_problems#autofill',
        as: 'autofill_marks'
      post 'upload-report/:id', to: 'long_problems#upload_report',
                                 as: 'upload_report'
      get 'mark-solo/:id', to: 'long_problems#mark_solo', as: :mark_solo
      post 'submit-temporary-markings/:id',
           to: 'long_problems#submit_temporary_markings',
           as: :submit_temporary_markings
      post 'submit-final-markings/:id',
           to: 'long_problems#submit_final_markings', as: :submit_final_markings
      get 'mark-final/:id', to: 'long_problems#mark_final', as: :mark_final
    end

    resources :long_submissions, path: '/long-submissions' do
      post 'submit', to: 'long_submissions#submit'
      delete 'destroy-subs', to: 'long_submissions#destroy_submissions'
      get 'download', to: 'long_submissions#download'
    end

    resources :feedback_questions, path: '/feedback-questions'

    post '/stop-nag/:id', to: 'user_contests#stop_nag', as: 'stop_nag'
  end

  # resources :market_items, path: '/market-items'

  get '/home', to: 'home#index'
  get '/faq', to: 'home#faq'
  get '/book', to: 'home#book'
  get '/donate', to: 'home#donate'
  get '/about', to: 'home#about'
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/contact', to: 'home#contact'
  get '/penguasa', to: 'home#admin', as: :admin
  post '/masq', to: 'home#masq'
  delete '/masq', to: 'home#unmasq'

  post '/line-bot', to: 'line#callback'
  post '/travis', to: 'travis#pass'

  namespace :ktom do
    get 'soal', to: redirect('https://docs.google.com/document/d/' \
    '15jvs6JbssVYYcEVWi1W_p6teR1AJ5op-0R6qg1Ir-lQ')
    get 'prod', to: redirect('https://docs.google.com/document/d/' \
    '1gmxPLbdkTdUtR6I5dKhadZ8lGTdzwx9qvUEn49JQAug')
    get 'produksi', to: redirect('https://docs.google.com/document/d/' \
    '1gmxPLbdkTdUtR6I5dKhadZ8lGTdzwx9qvUEn49JQAug')
  end

  match '*path', to: 'errors#error_4xx', via: :all
end
