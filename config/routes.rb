Kogdata::Application.routes.draw do

  get "conversations/show"

  get "conversations/delete"

  get "conversations/index"

  post 'conversations/create_message/:contact_id' => 'conversations#create_message'

  post "image/bind"
  delete "image/delete" => "image#delete"

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  resources :users do
    get 'all_photographer'
    resources :events
  end



  root :to => 'calendar#index/'
  get "home/index"
  get "calendar/index"
  get 'office/show'
  get 'office/all'
  get 'office/portfolio' => 'office#portfolio'

  match 'office/'=> "office#show"
  match 'profile/:id' => 'profile#show'
  #resources :users do
  #  resources :events
  #end


  match '/users/:user_id/messages' => 'messages#show_all',        :via => :get
  match '/users/:user_id/messages/:partner' => 'messages#new_message', :via => :post
  match '/users/:user_id/messages/:partner' => 'messages#show_dialog', :via => :get
  match '/users/:user_id/messages' => 'messages#create_message',  :via => :post
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
