module DocumentsHelper
  def show_without_breaks(x, prefix="", klass=:data)
    return "" if x.blank?
    prefix + "<span class='document-#{klass}'>" + h(x) + "</span>"
  end
  
  def show(x, prefix="", klass=:data)
    return "" if x.blank?
    prefix + "<span class='document-#{klass}'>" + h(x) + "</span><br />"
  end
  
  def show_names(document)
    result = ""
    document.names.reject{|name| name == document.author }.each_with_index do |author, index|
      result += "; " unless 0 == index
      result += link_to_unless_current h(author.name), :action => 'author', :id => author
    end
    return "" if result == ""
    result += "<br />"
  end
  
  def show_parent(document)
    parent = document.parent
    return "" unless parent

    volume = " "
    volume += document.month_of_serial if document.month_of_serial
    volume += document.collection_volume if document.collection_volume    
    "Pubblicato in: " + link_to_unless_current(h(parent.title), :action => 'show', :id => parent.id) + volume
  end
  
  def link_to_document(document)
    link_to h(document.title.sub("*", "")), document_url(document)
  end
  
  def show_children(document)
    children = document.children
    return "" unless children.size > 0
    case document.hierarchy_type
    when "issued_with"
      result = "Pubblicato con: "
    else
      result = "Comprende: "
    end
    result += "<ul>"
    result += children.map {|child| list_item link_to_document(child) }.join("\n")
    result += "</ul>"
    result
  end
  
  def list_item(x)
    "<li>#{x}</li>"
  end
  
end
