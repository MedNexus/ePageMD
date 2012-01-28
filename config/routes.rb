VirtualPagers::Application.routes.draw do
  devise_for :users

  match 'sign_on_off/add_pager' => "sign_onto_pager#add_pager"
  match 'sign_on_off/multiple' => "sign_onto_pager#multiple"
  match 'sign_on_off/multiple/:pager_number' => "sign_onto_pager#multiple"
  match 'sign_on_off/multiple_process' => "sign_onto_pager#process_multiple"
  match 'sign_on_off' => "sign_onto_pager#index"
  match 'page/send' => 'send_page#send_page'
  match 'page' => 'send_page#index'
  match 'code' => 'send_page#code'
  match 'code/send' => 'send_page#send_code'
  
  match 'log/:id' => "view_logs#index"
  match 'admin' => "virtual_pager#index" 
  
  resources :virtual_pagers, :sign_onto_pager, :send_page, :view_logs

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'send_page#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
