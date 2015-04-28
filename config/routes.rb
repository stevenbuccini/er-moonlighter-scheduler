Rails.application.routes.draw do
  resources :pay_periods

  get 'dashboard/view'

  get 'dashboard/index'

  resources :admins, :doctors, :pay_periods

  # We're implementing a custom controller for registration purposes.
  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout'}, controllers: {registrations: 'users/registrations'}
  # namespace :doctors do
  #   root "doctors#index"
  # end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  #get 'update-doctor-and-admin-pay-period', to: 'admin#update_doctor_and_admin_pay_period', as: "update_doctor_and_admin_pay_period"

  post '/send-email', to: 'admins#send_email', as: "send_email"
  get '/create-email', to: 'admins#create_email', as: "create_email"

  #Approve new user route:
  get '/approve-doctor/:user', to: 'admins#approve_doctor', as: "approve_doctor"
  get '/approve-new-admin/:user', to: 'admins#approve_new_admin', as: "approve_new_admin"

  get 'create-new-pay-period', to: 'admins#create_new_pay_period', as: "create_new_pay_period"
  get 'edit-current-pay-period', to: 'admins#edit_current_pay_period', as: "edit_current_pay_period"

  #Contact List
  get '/contact-list', to: 'admins#contact_list', as: "contact_list"
  #Pending Users List
  get '/pending-list', to: 'admins#pending_users', as: "pending_users"

  post '/request-shifts', to:'shifts#update', as: "sign_up_for_shifts"

  #payperiod routes goes here
  post 'create_next_pay_period', to: 'pay_periods#create_next', as: "create_next"


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
