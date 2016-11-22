Rails.application.routes.draw do
  root 'welcome#index'

  # Comment root and uncomment these to enter maintenance mode:
  # root 'application#maintenance'
  # match '*path', to: 'application#maintenance', via: :all

  resources :users do
    post 'mini-update', to: 'users#mini_update'
    get 'change-password', to: 'users#change_password'
    post 'change-password', to: 'users#process_change_password'
    get 'change-notifications', to: 'users#change_notifications'
    patch 'referrer-update', to: 'users#referrer_update'
    post 'change-notifications', to: 'users#process_change_notifications',
                                 as: 'process_change_notifications'
  end

  get '/sign', to: 'welcome#sign'
  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  post '/forgot', to: 'users#process_forgot_password'

  post '/check', to: 'users#check_unique'
  get '/verify/:verification', to: 'users#verify', as: :verify
  get 'reset-password/:verification', to: 'users#reset_password',
                                      as: 'reset_password'
  post 'reset-password', to: 'users#process_reset_password',
                         as: 'process_reset_password'

  resources :roles, only: [:create, :destroy] do
    collection do
      get '', to: 'roles#manage', as: ''
    end
  end

  resources :contests do
    get 'admin', to: 'contests#admin'
    get 'rules', to: 'contests#show_rules'
    post 'rules', to: 'contests#accept_rules'
    get 'feedback', to: 'contests#give_feedback'
    post 'feedback', to: 'contests#feedback_submit'
    get 'download-feedback', to: 'contests#download_feedback',
                             defaults: { format: 'csv' }
    get 'summary', to: 'contests#summary'
    get 'download-results', to: 'contests#download_results',
                            defaults: { format: 'pdf' }
    post 'copy-feedback-questions', to: 'feedback_questions#copy'
    delete 'destroy-short-probs', to: 'contests#destroy_short_probs'
    delete 'destroy-long-probs', to: 'contests#destroy_long_probs'
    delete 'destroy-feedback_qns', to: 'contests#destroy_feedback_qns'

    resources :short_problems, path: '/short-problems'
    post 'create-short-submissions', to: 'contests#create_short_submissions'
    resources :long_problems, path: '/long-problems'

    resources :long_submissions, path: '/long-submissions' do
      post 'submit', to: 'long_submissions#submit'
      delete 'destroy-subs', to: 'long_submissions#destroy_submissions'
      get 'download', to: 'long_submissions#download'
    end

    resources :feedback_questions, path: '/feedback-questions'

    post 'give-points', to: 'contests#give_points'

    get 'pdf', to: 'contests#download_pdf'
    get 'ms-pdf', to: 'contests#download_marking_scheme'
    get 'reports', to: 'contests#download_reports'

    post 'read-problems', to: 'contests#read_problems'
    get 'send-certificates', to: 'contests#send_certificates'
  end

  get '/download-submissions/:id', to: 'long_problems#download',
                                   as: 'download_submissions'
  post '/autofill-marks/:id', to: 'long_problems#autofill', as: 'autofill_marks'
  post '/start-mark-final/:id', to: 'long_problems#start_mark_final',
                                as: 'start_mark_final'
  post '/upload-report/:id', to: 'long_problems#upload_report',
                             as: 'upload_report'
  post '/stop-nag/:id', to: 'user_contests#stop_nag', as: 'stop_nag'

  resources :market_items, path: '/market-items'

  get '/mark-solo/:id', to: 'long_problems#mark_solo', as: :mark_solo
  post '/submit-temporary-markings/:id',
       to: 'long_problems#submit_temporary_markings',
       as: :submit_temporary_markings
  post '/submit-final-markings/:id',
       to: 'long_problems#submit_final_markings', as: :submit_final_markings
  get '/mark-final/:id', to: 'long_problems#mark_final', as: :mark_final

  %w(home rumah utama).each { |r| get "/#{r}", to: 'home#index' }
  %w(faq faqs pertanyaan).each { |r| get "/#{r}", to: 'home#faq' }
  %w(book books buku).each { |r| get "/#{r}", to: 'home#book' }
  %w(donate donasi sumbang).each { |r| get "/#{r}", to: 'home#donate' }
  %w(about tentang).each { |r| get "/#{r}", to: 'home#about' }
  %w(privacy privasi).each { |r| get "/#{r}", to: 'home#privacy' }
  %w(terms syarat ketentuan).each { |r| get "/#{r}", to: 'home#terms' }
  %w(contact kontak hubungi).each { |r| get "/#{r}", to: 'home#contact' }

  get '/penguasa', to: 'home#admin', as: :admin
  post '/masq', to: 'home#masq'
  delete '/masq', to: 'home#unmasq'

  get '/assign/:id', to: 'contests#assign_markers', as: :assign_markers
  post 'create-marker', to: 'roles#create_marker'
  delete 'remove-marker', to: 'roles#remove_marker'

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
