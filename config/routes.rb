Arpameeting::Application.routes.draw do
  get "recharges/new"

  get "recharges/create"

  get "new/create"

  get "orders/new"

  get "sessions/new"

  resources :users, :only => [:show, :new, :create, :edit, :update]
  resources :sessions, :only => [:new, :create, :destroy]
 
  resources :orders, :only => [:new, :create]
  resources :recharges, :only => [:new, :create]
 
  #get "home/index"
  resources :rooms
  resources :services, :only => [:index]
  
  #match 'rooms' => 'rooms#index', :via => :get, :as => 'rooms'
  #match 'rooms' => 'rooms#create', :via => :post, :as => 'rooms'
  #match 'rooms/new' => 'rooms#new', :as => 'new_rooms'
  
  match 'rooms/:id_room/participants/:id_participant' => 'rooms#show', :as => 'room_participant'
  
  match 'signup'    => 'users#new'
  match 'signin'    => 'sessions#new'
  match 'sessions'  => redirect('signin')
  match 'signout'   => 'sessions#destroy'

  match 'orders/new/express' => 'orders#express',:as => 'express_new_order'

  match 'api' => 'api_docs#index', :as => 'api_docs'

  # API Routing
  namespace :api_v1, :path => 'api/1' do
    resources :rooms
    resources :services, :only => [:index]
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
