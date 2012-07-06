ScholarSphere::Application.routes.draw do
  # Routes for Blacklight-specific functionality such as the catalog
  Blacklight.add_routes(self)

  # Route path-less requests to the index view of catalog
  root :to => "catalog#index"

  # "Recently added files" route for catalog index view
  match "catalog/recent" => "catalog#recent", :as => :catalog_recent_path

  # Set up user routes
  devise_for :users

  # Generic file routes
  resources :generic_files, :path => :files, :except => :index do
    member do
      post 'audit'
      get :add_user_permission
      get :add_group_permission
      post 'permissions'
    end
  end

  # Downloads controller route
  resources :downloads, :only => "show"

  # Logout route to destroy session
  match 'logout' => 'sessions#destroy'

  # Dashboard routes (based on catalog routes)
  match 'dashboard' => 'dashboard#index', :as => :dashboard
  match 'dashboard/facet/:id' => 'dashboard#facet', :as => :dashboard_facet

  # Authority vocabulary queries route
  match 'authorities/:model/:term' => 'authorities#query'

  # LDAP-related routes for group and user lookups
  match 'directory/user/:uid' => 'directory#user'
  match 'directory/user/:uid/groups' => 'directory#user_groups'
  match 'directory/group/:cn' => 'directory#group', :constraints => { :cn => /.*/ }

  # Batch edit routes
  match 'batches/:id/edit' => 'batch#edit', :as => :batch_edit
  match 'batches/:id/' => 'batch#update', :as => :batch_generic_files

  # Contact form routes
  match 'contact' => 'contact_form#create', :via => :post, :as => :contact_form_index
  match 'contact' => 'contact_form#new', :via => :get, :as => :contact_form_index

  # Static page routes (workaround)
  match ':action' => 'static#:action', :constraints => { :action => /about|contact|help|terms/ }

  # Catch-all (for routing errors)
  match '*error' => 'errors#routing'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
