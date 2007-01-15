module DocumentsHelper
  def show(x, prefix="")
    return "" unless x
    prefix + h(x) + "<br />"
  end
  
  def show_names(document)
    result = ""
    document.names.each_with_index do |author, index|
      result += "; " unless 0 == index
      result += link_to_unless_current h(author.name), :action => 'author', :id => author
    end
    result += "<br />"
  end
  
  def show_published_in(document)
    parent = document.parent
    return "" unless parent
    show parent.title, "Pubblicato in: "
  end
  
  def show_published_with(document)
    children = document.children
    return "" unless children.size > 0
    result = "Pubblicato con: "
    result += children.map {|child| h child.title}.join("; ")
    result
  end
  
end
