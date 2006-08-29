# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def menuitem_tag(text, options)
    # default options
    options[:controller] = 'content' unless options[:controller]
    options[:action] = 'page' unless options[:action]
    
    # if not a link, then give it a meaningful id
    link_to_unless_current(text, options) do |text|
      "<span id='menuitem-current'>#{text}</span>"
    end
  end
  
  def upper_right_image
    if @content && @content.image
      url_for_file_column(@content, "image")
    else
      'front-home.jpg'
    end
  end
end
