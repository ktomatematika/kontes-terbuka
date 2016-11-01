# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'welcome#index'

  resources :users do
    member do
      post 'mini-update', to: 'users#mini_update'
      get 'change-password', to: 'users#change_password'
      post 'change-password', to: 'users#process_change_password'
    end

    collection do
      get 'sign', to: 'welcome#sign'
      get 'register', to: 'users#new'
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      post 'forgot', to: 'users#process_forgot_password'

      post 'check', to: 'users#check_unique'
      get 'verify/:verification', to: 'users#verify', as: 'verify'
      get 'reset-password/:verification', to: 'users#reset_password',
                                          as: 'reset_password'
      post 'reset-password/:verification', to: 'users#process_reset_password'
    end
  end

  resources :user_notifications, only: [] do
    member do
      get '', to: 'user_notifications#new', as: ''
      post '', to: 'user_notifications#flip'
    end
  end

  resources :contests, shallow: true do
    member do
      get 'admin', to: 'contests#admin'
      get 'summary', to: 'contests#summary'
      post 'read-problems', to: 'contests#read_problems'
      get 'download-results', to: 'contests#download_results',
                              defaults: { format: 'pdf' }
      get 'pdf', to: 'contests#download_pdf'
      get 'ms', to: 'contests#download_marking_scheme'
    end

    resources :short_problems, path: '/short-problems',
                               except: [:index, :new, :show] do
      collection do
        delete 'destroy-on-contest', to: 'short_problems#destroy_on_contest'
      end
    end

    resources :short_submissions, path: '/short-submissions', only: [] do
      collection do
        post '', to: 'short_submissions#create_on_contest', as: ''
      end
    end

    resources :long_problems, path: '/long-problems',
                              except: [:index, :new, :show] do
      member do
        get 'marker', to: 'roles#assign_markers'
        post 'marker', to: 'roles#create_marker'
        delete 'marker', to: 'roles#remove_marker'
        get 'download/:id', to: 'long_problems#download', as: 'download'
        post 'autofill/:id', to: 'long_problems#autofill', as: 'autofill'
        post 'upload-report/:id', to: 'long_problems#upload_report',
                                  as: 'upload_report'
        get 'start-mark-final/:id', to: 'long_problems#start_mark_final',
                                    as: 'start_mark_final'
      end

      collection do
        delete 'destroy-on-contest', to: 'long_problems#destroy_on_contest'
      end

      resources :temporary_markings, path: 'temporary-markings', only: [] do
        collection do
          get '', to: 'temporary_markings#new_on_long_problem', as: ''
          post '', to: 'temporary_markings#create_on_long_problem'
        end
      end

      resources :long_submissions, path: '/long-submissions', only: [] do
        member do
          get '', to: 'long_submissions#download', as: ''
          post '', to: 'long_submissions#submit'
          delete '', to: 'long_submissions#destroy_submissions'
        end

        collection do
          get '', to: 'long_submissions#mark', as: ''
          post '', to: 'long_submissions#submit_mark'
        end
      end
    end

    resources :feedback_questions, path: '/feedback-questions',
                                   except: [:index, :new, :show] do
      collection do
        post 'copy', to: 'feedback_questions#copy_across_contests'
        delete '', to: 'feedback_questions#destroy_on_contest'
      end
    end

    resources :feedback_answers, path: '/feedback-answers', only: [] do
      collection do
        get 'new', to: 'feedback_answers#new_on_contest', as: 'new'
        get '', to: 'feedback_answers#download_on_contest', as: ''
        post '', to: 'feedback_answers#create_on_contest'
      end
    end
  end

  resources :user_contests, only: [:new, :create] do
    member do
      post '/stop-nag/:id', to: 'user_contests#stop_nag', as: 'stop_nag'
    end
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
