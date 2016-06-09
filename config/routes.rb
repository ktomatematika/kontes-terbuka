Rails.application.routes.draw do

	mount RailsAdmin::Engine => '/penguasa', as: 'rails_admin'

	scope '/mulpin' do
		authenticated :user do
			root to: 'home#index', as: :authenticated_root
		end

		resources :province do
			resources :users
		end

		resources :status do
			resources :users
		end

		resources :users
		resources :roles
		resources :contests do
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

		root "welcome#index"

		get '/sign' => 'welcome#sign'
		get '/register' => 'users#new'

		get '/login' => 'sessions#new'
		post '/login' => 'sessions#create'
		get '/logout' => 'sessions#destroy', as: :logout

		get '/contests/:id/admin' => 'contests#admin', as: :contest_admin

		get '/home/index' => 'home#index'
		get '/faq' => 'home#faq'
		get '/book' => 'home#book'
		get '/sitemap' => 'home#sitemap'
		get '/about' => 'home#about'
		get '/contact' => 'home#contact'

		post '/short_problems/submit' => 'short_problems#submit'
		post '/long_problems/submit' => 'long_problems#submit'

		get '/magic' => 'home#send_magic_email', as: :magic

		get '/home/admin/' => 'home#admin'
	end
end
