ActionController::Routing::Routes.draw do |map|
  map.resources :join_team_requests

  # Routes for google oauth
  map.callback '/auth/:provider/callback/:id', :controller => "provider_auths", :action => 'create'
  map.failure '/auth/failure', :controller => 'provider_auths', :action => 'failure'

  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"

  map.connect 'question/select_questionnaire_type', :controller => "questionnaire", :action => 'select_questionnaire_type'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'

  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'

end
