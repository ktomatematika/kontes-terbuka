Rails.application.routes.draw do

	mount RailsAdmin::Engine => '/penguasa', as: 'rails_admin'
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

	get '/home/index' => 'home#index'
	get '/home/faq' => 'home#faq'
	get '/home/sitemap' => 'home#sitemap'
	get '/home/about' => 'home#about'
	get '/home/terms' => 'home#terms'
	get '/home/privacy' => 'home#privacy'
	get '/home/contact' => 'home#contact'

	post '/short_problems/submit' => 'short_problems#submit'

	get '/home/admin/' => 'home#admin'
	get '/contests/:id/admin' => 'contests#admin', as: :contest_admin
end
