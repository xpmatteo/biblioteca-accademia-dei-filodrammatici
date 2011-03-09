module DocumentsHelper
  def show_without_breaks(x, prefix="", klass=:data)
    return "" if x.blank?
    prefix + "<span class='document-#{klass}'>" + h(x) + "</span>"
  end

  def make_entry(x)
    if "" == x
      ""
    else
      x + "<br />"
    end
  end
  
  def show(x, prefix="", klass=:data)
    return "" if x.blank?
    make_entry(prefix + "<span class='document-#{klass}'>" + h(x) + "</span>")
  end
  
  def show_names(document)
    result = ""
    document.names.reject{|name| name == document.author }.each_with_index do |author, index|
      result += "; " unless 0 == index
      result += link_to_unless_current h(author.name), :action => 'author', :id => author
    end
    make_entry(result)
  end

  def show_publication(document)
    show document.publication, "", :publication
  end
  
  def show_parent(document)
    parent = document.parent
    return "" unless parent

    volume = " "
    volume += document.month_of_serial if document.month_of_serial
    volume += document.collection_volume if document.collection_volume    
    make_entry("Pubblicato in: " + 
      link_to_unless_current(h(parent.title_without_asterisk), :action => 'show', :id => parent.id) + 
      volume)
  end
  
  def link_to_document(document)
    # FIXME document_url(document) crashes on Storm, don't know why
    url = "/biblio/scheda/#{document.id}"
    link_to h(document.title_without_asterisk), url
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
    make_entry(result)
  end
  
  def list_item(x)
    "<li>#{x}</li>"
  end
  
  def use_manuscript_form
    @document && @document.edited_with_manuscript_form
  end
  
  def manuscript_only_text_field label_text, field_name
    return "" unless use_manuscript_form
    document_form_element :text_field, label_text, field_name, :size => 50
  end

  def manuscript_text_field label_text, field_name
    document_form_element :text_field, label_text, field_name, :size => 50
  end

  def manuscript_text_area label_text, field_name
    document_form_element :text_area, label_text, field_name, :size => "50x6"
  end

  def document_text_field label_text, field_name
    return "" if use_manuscript_form
    document_form_element :text_field, label_text, field_name, :size => 50
  end
  
  def document_text_area label_text, field_name
    return "" if use_manuscript_form
    document_form_element :text_area, label_text, field_name, :size => "50x6"
  end  
  
  def document_form_element kind, label_text, field_name, options
    %Q|<p><label for="document_#{field_name}">#{label_text}</label><br/>\n| +
    self.send(kind, 'document', field_name, options) +
    "</p>\n"
  end
end
