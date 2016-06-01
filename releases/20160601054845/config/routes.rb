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

	get '/contests/:id/admin' => 'contests#admin', as: :contest_admin

	get '/home/index' => 'home#index'
	get '/home/faq' => 'home#faq'
	get '/home/book' => 'home#book'
	get '/home/sitemap' => 'home#sitemap'
	get '/home/about' => 'home#about'
	get '/home/terms' => 'home#terms'
	get '/home/privacy' => 'home#privacy'
	get '/home/contact' => 'home#contact'

	post '/short_problems/submit' => 'short_problems#submit'
	post '/long_problems/submit' => 'long_problems#submit'

	get '/magic' => 'home#send_magic_email', as: :magic
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	get '/home/admin/' => 'home#admin'
end
