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
    case document.hierarchy_type
    when "issued_with", "composition", "serial"
      return "Pubblicato in: " + link_to_unless_current(h(parent.title), :action => 'show', :id => parent.id)
    end
  end
  
  def show_children(document)
    children = document.children
    return "" unless children.size > 0
    case document.hierarchy_type
    when "issued_with"
      result = "Pubblicato con: "
      result += children.map {|child| h child.title}.join("; ")
    when "composition", "serial"
      result = "Comprende: <ul>"
      result += children.map {|child| list_item(h(child.title))}.join("\n")
      result += "</ul>"
    else
      result = "Comprende: <ul>"
      result += children.map {|child| list_item(h(child.title))}.join("\n")
      result += "</ul>"
    end
    result
  end
  
  def list_item(x)
    "<li>#{x}</li>"
  end
  
end
