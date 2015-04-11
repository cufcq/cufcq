Cufcq::Application.routes.draw do

  get "errors/file_not_found"
  get "errors/unprocessable"
  get "errors/internal_server_error"
  root 'static_pages#home'

  #Users don't need to access all of the fcqs. This adds to much stress on the server. 

  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  match '/fcqs', to: 'static_pages#help',    via: 'get'
  match '/feedback', to: 'static_pages#feedback',    via: 'get'
  match '/disclaimer', to: 'static_pages#disclaimer',    via: 'get'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',    to: 'static_pages#about',    via: 'get'


  resources :courses, :except => [:new, :edit, :delete]
  resources :departments, :except => [:new, :edit, :delete]
  resources :instructors, :except => [:new, :edit, :delete]
  # resources :instructors_test
  resources :fcqs, :except => [:new, :edit, :delete]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
#root 'static_pages/home'

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

  # match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
