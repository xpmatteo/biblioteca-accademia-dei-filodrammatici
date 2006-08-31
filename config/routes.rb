ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  map.connect '', :controller => "news"

  map.connect 'diplomati/:action/:id',  :controller => "graduates"
  map.connect 'docenti/:action/:id',    :controller => "teachers"
  map.connect 'login',                  :controller => "login", :action => "login"
  map.connect ':name',                  :controller => "content", :action => 'page'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
