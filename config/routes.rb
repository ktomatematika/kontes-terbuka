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
	# The priority is based upon order of creation: first created -> highest priority.
	# See how all your routes lay out with "rake routes".

	# You can have the root of your site routed with "root"
	# root 'welcome#index'

	# Example of regular route:
	#   get 'products/:id' => 'catalog#view'

	# Example of named route that can be invoked with purchase_url(id: product.id)
	#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

	# Example resource route (maps HTTP verbs to controller actions automatically):
	#   resources :products

	# Example resource route with options:
	#   resources :products do
	#     member do
	#       get 'short'
	#       post 'toggle'
	#     end
	#
	#     collection do
	#       get 'sold'
	#     end
	#   end

	# Example resource route with sub-resources:
	#   resources :products do
	#     resources :comments, :sales
	#     resource :seller
	#   end

	# Example resource route with more complex sub-resources:
	#   resources :products do
	#     resources :comments
	#     resources :sales do
	#       get 'recent', on: :collection
	#     end
	#   end

	# Example resource route with concerns:
	#   concern :toggleable do
	#     post 'toggle'
	#   end
	#   resources :posts, concerns: :toggleable
	#   resources :photos, concerns: :toggleable

	# Example resource route within a namespace:
	#   namespace :admin do
	#     # Directs /admin/products/* to Admin::ProductsController
	#     # (app/controllers/admin/products_controller.rb)
	#     resources :products
	#   end
end
