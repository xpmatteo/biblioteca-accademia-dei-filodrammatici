require 'sinatra'

def sidebar_menu_items
  [
    ["La Biblioteca", "/"],
    ["Ricerca alfabetica", "/biblio/autori/A"],
    ["Ricerca completa", "/biblio/search"],
  ]
end

def link_to text, options, attributes={}
  href = href_from(options)
  attrs=""
  attributes.each_pair do |attr_key, attr_value|
    attrs += " #{attr_key}='#{attr_value}'"
  end
  "<a href='#{href}'#{attrs}>#{text}</a>"
end

def link_to_unless_current text, options, attributes={}
  if request.path_info == href_from(options)
    text
  else
    link_to text, options, attributes
  end
end

private def href_from options
  case options
  when String
    options
  when Hash
    options[:action]
  end
end



get '/' do
  erb :index
end