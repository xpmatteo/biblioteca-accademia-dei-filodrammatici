# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def menuitem_tag(text, options)
    # default options
    options[:controller] = 'content' unless options[:controller]
    options[:action] = 'page' unless options[:action]
    if options[:sub]
      options[:sub] = nil
      klass = ' class="submenuitem"'
    end
    
    if options[:name] && (content = Content.find_by_name(options[:name]))
      text = content.title
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
  
  def admin_link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)   
    link_to(name, options, html_options, *parameters_for_method_reference) if authorized?
  end
end
