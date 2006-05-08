class ContentController < ApplicationController
  def index
    params[:name] = 'welcome'
    page
    render :action => "page"
  end

  def page
    @content = Content.find_by_name(params[:name])
    @navigation_items = Content.find(:all, :conditions => 'show_in_navigation', :order => 'sort_value')
    redirect_to "/404.html" unless @content
  end
end
