# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def menuitem_tag(menuitem, options={})
    options[:controller] = menuitem.controller
    options[:action] = 'index'
    if options[:sub]
      options[:sub] = nil
      klass = ' class="submenuitem"'
    end
    
    if 'content' == options[:controller] && (content = Content.find(menuitem.item_id))
      text = content.title
      options[:name] = content.name
      options[:action] = 'page'
    end
    
    # if not a link, then give it a meaningful id
    item = link_to_unless_current(text, options) do |text|
      "<span id='menuitem-current'>#{text}</span>"
    end
    
    "<tr><td#{klass}>#{item}</td></tr>"
  end
  
  def upper_right_image
    if @content && @content.image
      url_for_file_column(@content, "image")
    else
      'front-home.jpg'
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
