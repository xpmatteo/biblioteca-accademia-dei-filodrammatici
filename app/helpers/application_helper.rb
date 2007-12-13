# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def sidebar_menu_items
    [
      ["La Biblioteca", "/"],
      ["Ricerca alfabetica", {:controller => "documents", :action => "authors", :initial => "A"}],
      ["Ricerca per secolo", {:controller => "documents", :action => "secolo"}],      
    ]
  end
  
  def menuitem_is_current?(menuitem)
    return false if params[:controller] != menuitem.controller
    return true if menuitem.controller != 'content'
    return false unless content = Content.find_by_name(params[:name])
    content.id == menuitem.item_id
  end
  
  def menuitem_is_current_section?(menuitem)
    return true if menuitem_is_current?(menuitem)
    for sub_item in menuitem.children
      return true if menuitem_is_current?(sub_item)
    end
    false
  end
  
  def menuitem_tag(menuitem, options={}, html_options={})
    options[:controller] = menuitem.controller
    options[:action] = 'index'
    if options[:sub]
      options[:sub] = nil
      klass = ' class="submenuitem"'
    end
        
    text = menuitem.title
    if 'content' == options[:controller] && (content = Content.find(menuitem.item_id))
      text = content.title
      options[:name] = content.name
      options[:action] = 'page'
    end
    
    # if not a link, then give it a meaningful id
    item = link_to_unless_current(text, options, html_options) do |text|
      "<span id='menuitem-current'>#{text}</span>"
    end
    
    "<tr><td#{klass}>#{item}</td></tr>"
  end
  
  def upper_right_image
    if @content && @content.image
      url_for_file_column(@content, "image")
    else
      @image_for_layout || 'front-home.jpg'
    end
  end
  
  def admin_link_to(name, options = {}, html_options = {}, *parameters_for_method_reference)   
    html_options[:class] = 'admin-link'
    if authorized? 
      "&nbsp;" + 
        link_to(name, options, html_options, *parameters_for_method_reference) +
        "&nbsp;" 
    end
  end
end
