require 'sinatra'
require "sinatra/activerecord"
require "tilt/erb"
require 'acts_as_tree_rails3'
# require 'acts_as_versioned'
require 'active_support/inflector'


Dir.glob('./app/{models,helpers,controllers}/*.rb').sort.each { |file|
  puts file
  require file
}

def pluralize(count, singular, plural)
  case count
  when 0
    "nessun #{singular}"
  when 1
    "un #{singular}"
  else
    "#{count} #{plural}"
  end
end

def sidebar_menu_items
  [
    ["La Biblioteca", "/"],
    ["Ricerca alfabetica", "/biblio/autori/A"],
    ["Ricerca completa", "/biblio/search"],
  ]
end

def link_to text, href, attributes={}
  attrs=""
  attributes.each_pair do |attr_key, attr_value|
    attrs += " #{attr_key}='#{attr_value}'"
  end
  "<a href='#{href}'#{attrs}>#{text}</a>"
end

def link_to_unless_current text, href, attributes={}
  if request.path_info == href
    text
  else
    link_to text, href, attributes
  end
end

get '/' do
  erb :'documents/index'
end

get '/biblio/autori/:initial' do
  @authors = Author.find(:all, :order => 'name', :conditions => ['upper(left(name, 1)) = upper(?)', params[:initial]])
  @page_title = "Iniziale '#{params[:initial]}': " + pluralize(@authors.size, "autore", "autori")
  erb :'documents/list'
end

# get '/biblio/find' do
#   @documents = paginate(:keywords => params[:q])
#   @page_title = "Ricerca \"#{params[:q]}\": " + pluralize(@documents.total_entries, "risultato", "risultati")
#   render :template => 'documents/list'
# end
