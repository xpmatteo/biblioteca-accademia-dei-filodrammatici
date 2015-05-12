require 'sinatra'
require "sinatra/activerecord"
require "tilt/erb"
require 'active_support/inflector'
require 'will_paginate'
require 'will_paginate/active_record'

Dir.glob('./lib/*.rb').sort.each { |file|
  puts file
  require file
}

def pluralize(count, singular, plural, options={})
  case count
  when 0
    if options[:feminine]
      "nessuna " + singular
    else
      "nessun " + singular
    end
  when 1
    if options[:feminine]
      "una " + singular
    else
      "un " + singular
    end
  else
    count.to_s + " " + plural
  end
end

def pluralize_schede(count=@documents.total_entries)
  pluralize(count, "scheda", "schede", :feminine => true)
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

def h(text)
  Rack::Utils.escape_html(text)
end

def with_indifferent_access(hash)
  hash.keys.each do |key|
    hash[key.to_sym] = hash[key]
  end
  hash
end

def paginate(options)
  unless options[:page]
    options.merge!(:page => params[:page] || "1")
  end
  Document.paginate(with_indifferent_access(options))
end

def singleton_collection(document)
  WillPaginate::Collection.create(1, 10) { |pager| pager.replace [document] }
end

def authorized?
  false
end

get '/' do
  erb :index
end

get '/biblio/autori/:initial' do
  @authors = Author.find(:all, :order => 'name', :conditions => ['upper(left(name, 1)) = upper(?)', params[:initial]])
  @page_title = "Iniziale '#{params[:initial]}': " + pluralize(@authors.size, "autore", "autori")
  erb :authors
end

get '/biblio/autore/:author_id' do
  author = Author.find(params[:author_id])
  @documents = paginate(:author_id => author.id)
  @page_title = author.name + ": " + pluralize_schede
  erb :documents_list
end

get '/biblio/search' do
  @documents = paginate(params)
  if @documents
    @page_title = 'Ricerca completa: ' + pluralize_schede
  else
    @page_title = "Ricerca completa"
  end
  erb :search
end

get '/biblio/scheda/:id' do
  document = Document.find(params[:id])
  @page_title = document.title_without_asterisk
  @documents = singleton_collection(document)
  erb :documents_list
end

get '/biblio/find' do
  @documents = paginate(:keywords => params[:q])
  @page_title = "Ricerca \"#{params[:q]}\": " + pluralize(@documents.total_entries, "risultato", "risultati")
  erb :documents_list
end

get '/biblio/marca/:id' do
  emblem = PublishersEmblem.find(params[:id])
  @documents = paginate(:publishers_emblem_id => params[:id])
  @page_title = 'Marca "' + emblem.description + '": ' + pluralize_schede
  erb :documents_list
end

get '/biblio/collezione' do
  @documents = paginate(:collection_name => params[:name])
  @page_title = 'Collezione "' + params[:name] + '": ' + pluralize_schede
  erb :documents_list
end
