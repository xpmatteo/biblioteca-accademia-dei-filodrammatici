ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  map.connect '', :controller => "welcome"

  map.connect         'notizie/:action/:id',      :controller => "news"
  map.connect         'diplomati/:action/:id',    :controller => "graduates"
  map.connect         'docenti/:action/:id',      :controller => "teachers"
  map.author_initial  'biblio/autori/:initial',   :controller => "documents", :action => "authors"
  map.author          'biblio/autore/:id',        :controller => "documents", :action => "author"
  map.document        'biblio/scheda/:id',        :controller => "documents", :action => "show"
  map.connect         'biblio/:action/:id',       :controller => "documents"

  map.connect         'login',                    :controller => "login", :action => "login"
  map.connect         ':name',                    :controller => "content", :action => 'page'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
