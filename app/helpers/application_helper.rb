# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def sidebar_menu_items
    [
      ["La Biblioteca", "/"],
      ["Ricerca alfabetica", {:controller => "documents", :action => "authors", :initial => "A"}],
      ["Ricerca per secolo", {:controller => "documents", :action => "secolo"}],      
    ]
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
    
  def all_authors
    Author.find(:all, :order => 'name').map {|a| [a.name, a.id]}
  end
end
