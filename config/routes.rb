MaphubPortal::Application.routes.draw do

  devise_for :users, :admins

  resources :annotations
  
  resources :collections do
    resources :maps
  end
  
  resources :maps do
    resources :annotations
    resources :collections
  end
  
  resources :users do
    resources :maps
    resources :annotations
    resources :collections
  end
  # deactivate a user (the controller will check that you can only deactivate yourself)
  match 'users/:id/deactivate' => 'users#deactivate', :as => :deactivate
  match "terms" => 'home#terms'
  match "contact" => 'home#contact'
  match "help" => 'home#help'
  
  # default homepage
  get "home/index"
  root :to => "home#index"
  
  # administrator namespace (create separate controllers for these!)
  namespace 'admin' do 
    resources :maps, :collections, :users, :annotations
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
