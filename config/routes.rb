Heatlab::Application.routes.draw do

  
  resources :eventgroups


  match '/my_projects/:id/:job_id', to: 'my_projects#showjob'

  match '/events_all',    to: 'events2#index'
  match '/events_all/print',    to: 'events2#print'
  match '/events_all/print/xls',  to: 'events2#xls'

  resources :main_worklists do
    resources :main_jobs do
      match '/worklist/:month',  to: 'main_jobs#worklist'
      match '/worklist/:month',  to: 'main_jobs#worklist' 
      match '/worklist/:month/worklist_update',  to: 'main_jobs#worklist_update' 
      match '/worklist/:month/export_xls',  to: 'main_jobs#export_xls'
      match '/jobcheck',  to: 'main_jobs#jobcheck' 
      match '/jobcheck_update',  to: 'main_jobs#jobcheck_update' 
    end 
  end


  resources :projects do
    resources :eventgroups
    resources :events
    match '/jobcheck',  to: 'projects#jobcheck' 
    match '/jobcheck/:year',  to: 'projects#jobcheck_year' 
    match '/jobcheck/:year/jobcheck_update',  to: 'projects#jobcheck_update'
    match '/jobcheck/:year/export_xls',  to: 'projects#export_xls'

    resources :jobs do
      match '/worklist/:year/:month',  to: 'jobs#worklist' 
      match '/worklist/:year/:month/worklist_update',  to: 'jobs#worklist_update' 
      match '/worklist/:year/:month/export_xls',  to: 'jobs#export_xls' 
      match '/worklist_autocomplete', to: 'jobs#worklist_autocomplete'
    end

    resources :project_positions do
      collection { post :sort}
      resources :project_activities do
        collection { post :sort}
      end
    end

    
  end

  resources :my_projects do
    match '/:job_id/worklist/:year/:month',  to: 'my_projects#worklist' 
    match '/:job_id/worklist/:year/:month/worklist_update',  to: 'my_projects#worklist_update' 
  end

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users do
    collection { get :vyhlaska}
    collection { get :smlouva}
    collection { get :duchod}
    collection { get :ridic}
  end

  get '/users/:id/edit/:from',  to: 'users#edit' 
  put '/users/:id/edit/:from',  to: 'users#edit' 

  resources :sessions
  
  root to: 'static_pages#home'
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
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
