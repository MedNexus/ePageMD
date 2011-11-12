VirtualPagers::Application.routes.draw do
  devise_for :users

  match 'sign_onto_pager/add_pager' => "sign_onto_pager#add_pager"
  match 'transmit' => 'send_page#send_page'
  match 'send_page' => 'send_page#index'
  match 'view_logs/:id' => "view_logs#index"
  resources :virtual_pagers, :sign_onto_pager, :send_page, :view_logs

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'send_page#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
