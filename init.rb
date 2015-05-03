require 'sinatra'

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
  erb :index
end