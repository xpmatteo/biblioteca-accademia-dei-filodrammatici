# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def navigation_items
    Content.find(:all, :conditions => 'show_in_navigation', :order => 'sort_value')
  end
end
