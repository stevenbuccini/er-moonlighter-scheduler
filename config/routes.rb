Rails.application.routes.draw do
  get 'dashboard/view'

  get 'dashboard/index'

  resources :admins, :doctors

  # We're implementing a custom controller for registration purposes.
  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout'}, controllers: {registrations: 'users/registrations'}
  # namespace :doctors do
  #   root "doctors#index"
  # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  post '/send-mass-email', to: 'admins#send_mass_email', as: "send_mass_email"
  get '/create-new-email', to: 'admins#create_new_email', as: "create_new_email"

  post '/request-shifts', to:'shifts#update', as: "sign_up_for_shifts"

  # TO DO: Replace this with a splash page/login page
  root 'dashboard#index'

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
