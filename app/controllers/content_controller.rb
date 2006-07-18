class ContentController < ApplicationController
  def index
    params[:name] = 'welcome'
    page
    render :action => "page"
  end

  def page
    @content = Content.find_by_name(params[:name])
    if @content
      @image_url = @content.full_image_url
    else
      redirect_to "/404.html"
    end
  end

  def edit
    if request.post?
      @content = Content.find(params[:id])
      @content.title = params[:content][:title]
      @content.body = params[:content][:body]
      if @content.save
        redirect_to :action => 'page', :name => @content.name
      end
    else    
      @content = Content.find(params[:id])
    end
  end
end
