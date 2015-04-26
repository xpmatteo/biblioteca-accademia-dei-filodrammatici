ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  map.connect '', :controller => "documents"
  map.connect         'login',                    :controller => "login", :action => "login"

  map.author_initial  'biblio/autori/:initial',   :controller => "documents", :action => "authors"
  map.title_initial   'biblio/titoli/:title_initial',   :controller => "documents", :action => "titles"
  map.author          'biblio/autore/:id',        :controller => "documents", :action => "author"
  map.document        'biblio/scheda/:id',        :controller => "documents", :action => "show"
  map.collection      'biblio/collezione',        :controller => "documents", :action => "collection"
  map.connect         'biblio/marca/:id',         :controller => "documents", :action => "publishers_emblem"
  map.year            'biblio/anno/:year',        :controller => "documents", :action => "year"
  map.connect         'biblio/:action/:id',       :controller => "documents"

  # Install the default route as the lowest priority.
  map.connect         ':controller/:action/:id'
end
