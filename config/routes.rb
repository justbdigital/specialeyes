Rails.application.routes.draw do

  root 'venues#index'

  devise_for :consumers, controllers: { registrations: 'consumers/registrations', omniauth_callbacks: 'omniauth_callbacks', invitations: 'users/invitations' }

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  resources :venues, only: [:show, :update, :index, :create]
  resources :transactions, only: [:new, :create, :index]
  resources :bookings, only: [:new] do
    post :confirm, on: :collection
  end
  resource :cart, only: [:show]
  resource :balance, only: [:create] do
    get :show, as: :gifts
  end
  resources :reviews, only: [:new, :create, :index]
  resources :vouchers, only: [:update] do
    get :add_gift, on: :collection
  end
  get 'gift_card', to: 'vouchers#buy_gift_card', as: :buy_gift_card

  scope '/pro' do
    devise_for :pros, controllers: { invitations: 'users/invitations' }

    resources :pros
    resources :treatments
    resources :treatment_groups
    resources :teams, only: [:create, :show] do
      post :add_member, on: :member
      get :check_for_team, on: :collection
    end
    resources :bookings, only: [:create, :index, :destroy] do
      get :calendar, on: :collection
      post :mark_as_unavailable, on: :collection
      post :complete, on: :member
    end
    resources :venues, only: [:edit, :new]
    resources :bank_accounts, only: [:update, :edit, :new, :create]
    resource :dashboard, only: [:show]
  end

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
