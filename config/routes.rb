Circletime::Application.routes.draw do
  resources :memberships

  resources :circles

  devise_for :users, :controllers => { :invitations => 'users/invitations' }
  
  resources :users
  
  resources :applications

  resources :jobs

  resources :work_units

  resources :job_types
  
  root :to => "pages#home"
  
  match '/users/auth/:provider/callback' => 'authentications#create'

  match '/dashboard' => 'users#dashboard' , :as => :dashboard

  match '/facebook_friends' => 'users#facebook_friends', :as => :facebook_friends

  match '/facebook_friends/invite' => 'users#fb_create' , :via => :post

  match '/jobs/:id/sign_up' => 'jobs#sign_up' , :as => :sign_up_for_job

  match '/jobs/open/close' => 'jobs#close_open_jobs' , :as => :close_open_jobs
  
  match '/jobs/:id/cancel' => 'jobs#cancel_assignment', :as => :cancel_job_assignment

  match '/jobs/:id/invite' => 'jobs#send_invites', :as => :send_job_invites
      
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
  # match ':controller(/:action(/:id(.:format)))'
end
