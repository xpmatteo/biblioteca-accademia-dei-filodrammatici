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
end
