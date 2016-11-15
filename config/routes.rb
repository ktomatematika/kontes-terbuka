# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'welcome#index'
  # Comment root and uncomment these to enter maintenance mode:
  # root 'application#maintenance'
  # match '*path', to: 'application#maintenance', via: :all

  resources :users do
    member do
      post 'mini-update', to: 'users#mini_update'
      get 'change-password', to: 'users#change_password'
      post 'change-password', to: 'users#process_change_password'
      patch 'referrer-update', to: 'users#referrer_update'
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

  resources :user_notifications, path: '/user-notifications', only: [] do
    collection do
      get '', to: 'user_notifications#edit_on_user', as: ''
      post '', to: 'user_notifications#flip'
    end
  end

  resources :contests, except: [:edit], shallow: true do
    member do
      get 'admin', to: 'contests#admin'
      get 'summary', to: 'contests#summary'
      post 'read-problems', to: 'contests#read_problems'
      get 'results', to: 'contests#download_results',
                     defaults: { format: 'pdf' }
      get 'problem-pdf', to: 'contests#download_problem_pdf'
      get 'marker', to: 'roles#assign_markers'
      get 'ms-pdf', to: 'contests#download_marking_scheme'
      get 'reports', to: 'contests#download_reports'
    end

    resources :user_contests, path: '/user-contests', only: [:new, :create] do
      member do
        post 'stop-nag', to: 'user_contests#stop_nag'
      end
    end

    resources :short_problems, path: '/short-problems',
                               except: [:index, :new, :show] do
      collection do
        delete '', to: 'short_problems#destroy_on_contest', as: ''
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
        post 'marker', to: 'roles#create_marker'
        delete 'marker', to: 'roles#remove_marker'
        get 'submissions', to: 'long_problems#download_submissions'
        patch 'autofill', to: 'long_problems#autofill'
        post 'upload-report', to: 'long_problems#upload_report'
        patch 'start-mark-final', to: 'long_problems#start_mark_final'
      end

      collection do
        delete '', to: 'long_problems#destroy_on_contest', as: ''
      end

      resources :temporary_markings, path: 'temporary-markings', only: [] do
        collection do
          get '', to: 'temporary_markings#new_on_long_problem', as: ''
          post '', to: 'temporary_markings#modify_on_long_problem'
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
        delete '', to: 'feedback_questions#destroy_on_contest', as: ''
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

  resources :market_items, path: '/market-items'

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

  post '/line-bot', to: 'line#callback'
  post '/travis', to: 'travis#pass'

  match '*path', to: 'errors#error_4xx', via: :all
end
