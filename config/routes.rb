Kogdata::Application.routes.draw do

  root :to => 'calendar#index'

  get  'conversations/:id'             => 'conversations#show'
  get  'conversations'                => 'conversations#index'
  post 'conversations/create_message'
  get  'conversations/delete_message/:m_id' => 'conversations#delete_message'

  post 'image/bind'
  delete 'image/delete'
 
  post 'users/search' => 'users#search'
  post 'users/search/:input' => 'users#search'
  post '/users/validate' => 'users#validate'
  post '/users/validate/:field' => 'users#validate'
  post '/users/:id/validate/:field' => 'users#validate'
  get 'users/edit'
  get 'users/merge'
  post 'users/merge_on_submit'
  get 'users/get_info' => 'users#registration_after_omniauth'
  put 'users' => 'users#create'
  put 'users/:id' => 'users#update'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get 'welcome/index'
  get 'calendar/index'
  get 'calendar/new_form'
  get 'show_bookings' => 'calendar#show_bookings'
  get 'calendar/show_form/:event_id' =>  'calendar#show_form'
  get 'office/show'
  get 'office/all'
  get 'office/portfolio' => 'office#portfolio'
  match 'office/'=> 'office#show'

  resources :users do
    resources :events do
      post 'respond'
      put 'close'
      put 'reopen'
    end
    resources :social_links, only: [:index, :new, :create, :destroy]
  end

  #put 'users/:user_id/events/:id/close' => 'events#close'
  #put 'users/:user_id/events/:id/reopen' => 'events#reopen'

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
