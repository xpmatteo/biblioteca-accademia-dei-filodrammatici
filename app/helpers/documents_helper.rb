module DocumentsHelper
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
  
  def show_published_in(document)
    parent = document.parent
    return "" unless parent
    return "Pubblicato in: " + link_to_unless_current(h(parent.title), :action => 'show', :id => parent.id)
  end
  
  def show_published_with(document)
    children = document.children
    return "" unless children.size > 0
    result = "Pubblicato con: "
    result += children.map {|child| h child.title}.join("; ")
    result
  end
  
end
