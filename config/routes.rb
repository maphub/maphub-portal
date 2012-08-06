MaphubPortal::Application.routes.draw do

  devise_for :admins, :users
  
  resources :users, :only => [:show, :update, :index] do 
    resources :annotations, :only => [:show, :index, :destroy]
    resources :control_points, :only => [:show, :index, :destroy]
  end
  
  resources :maps, :only => [:show, :index] do 
    resources :annotations, :only => [:create, :index, :update, :destroy]
    resources :control_points, :only => [:create, :index, :update, :destroy]
  end
  
  resources :annotations, :only => [:index, :create, :update, :show, :destroy]
  resources :control_points, :only => [:index, :show, :destroy]
  
  # default homepage
  root :to => "home#index"

  # search controller
  match 'search' => 'home#search'
  match 'search/:q' => 'home#search'
  
  # status controller
  match 'status' => 'home#status'
  
  # static content
  match "help" => 'home#help'
  match "contact" => 'home#contact'
  
  match "/refresh" => "home#index", :refresh => true
  
  # tag lookup for annotations
  # the last constraint allows any characters in the parameter, see http://stackoverflow.com/questions/5369654
  # this is somehow interfering with other routes - dunno why though
  # boundary coordinates are optional here
  match '/maps/:map/annotations/tags' => 'annotations#tags', :as => "annotation_tag_find"
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
