SampleApp::Application.routes.draw do


  get 'my_profile' => 'users#my_profile', :as => :my_profile # my_profile_path => "/profiles/my_profile"
  put '/users/update_profile' => 'users#update_profile', :as => :update_profile
  
  
  match '/myconversations', :to => 'pages#myconversations', :as => :myconversations
  
  resources :users, do
    resources :microposts, :only => [:index]
  end
  
  
  resources :import_tables
    post 'import_tables/:id' => 'import_tables#merge'

    get "csv/import"

    post "csv/import" => 'csv#upload'
  
  
  resources :schools
  resources :votes,   :only => [:new, :create, :destroy]
  resources :sessions,   :only => [:new, :create, :destroy]
  resources :microposts, :only => [:create, :destroy] 
  resources :conversations
  resources :conversation_threads, :only => [:create]

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/twitter', :to => 'pages#twitter'
  match '/chatbots', :to => 'pages#chatbots'
  
  match '/help', :to => 'pages#help'
  match '/communications', :to => 'pages#communications'
  match '/winning', :to => 'pages#winning'
  match '/votesreal', :to => 'pages#votesreal'
  match '/votesfake', :to => 'pages#votesfake'
  match '/votingreal', :to => 'pages#votingreal'
  match '/votingfake', :to => 'pages#votingfake'


  match '/voteontweets', :to => 'pages#voteontweets'
  match '/mytweets', :to => 'pages#mytweets'
  
  match '/activityone', :to => 'pages#activityone'
  match '/activitytwo', :to => 'pages#activitytwo'
  match '/activitythree', :to => 'pages#activitythree'
  match '/activityfour', :to => 'pages#activityfour'
  
  match '/interest', :to => 'pages#interest'

  match '/my_school', :to => 'pages#my_school'
  match '/trusted_users', :to => 'pages#trusted_users'
  match '/reported_users', :to => 'pages#reported_users'
    
    
  match '/flag', :to => 'microposts#flag'
  match '/approve', :to => 'microposts#approve'
  
  match '/approve_user', :to => 'users#approve'
  match '/moderate_user', :to => 'users#moderate'
  match '/penalty', :to => 'microposts#penalise'
  
  

  
  # match 'users/:id/update_profile', :to =>'users#update_profile'
  #match 'users(/update_profile(/:id))',  :to =>'users#update_profile'

  root :to => 'pages#home'
  
   #root :to => 'pages#maintenance'

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
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
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
  #       get :recent, :on => :collection
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
