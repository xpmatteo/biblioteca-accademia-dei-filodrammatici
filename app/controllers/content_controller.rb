class ContentController < ApplicationController
  uses_tiny_mce
  
  def index
    params[:name] = 'welcome'
    page
    render :action => "page"
  end

  def page
    @content = Content.find_by_name(params[:name])
    unless @content
      path = "#{File.dirname(__FILE__)}/../../public/404.html"
      render :file => path, :status => 404
    end
  end

  def edit
    if request.post?
      @content = Content.find(params[:id])
      if @content.update_attributes(params[:content])
        redirect_to :action => 'page', :name => @content.name
      end
    else    
      @content = Content.find(params[:id])
    end
  end
end
