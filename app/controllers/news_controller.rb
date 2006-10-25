class NewsController < ApplicationController
  uses_tiny_mce MCE_OPTIONS
  before_filter :check_user_is_admin, :except => [ :index, :list, :show, :uptime ]

  verify :method => :post, :only => :destroy, :redirect_to => { :action => :index }

  def index
    @news_pages, @news = paginate :news, :order => 'created_at desc'
  end

  def show
    @news = News.find(params[:id])
  end

  def new
    @news = News.new
    if request.post?
      @news.attributes = params[:news]
      if @news.save
        flash[:notice] = "L'annuncio &egrave; stato creato"
        redirect_to :action => :show, :id => @news.id
      end
    end
  end

  def edit
    @news = News.find(params[:id])
    if request.post?
      if @news.update_attributes(params[:news])
        flash[:notice] = "L'annuncio &egrave; stato modificato"
        redirect_to :action => :show, :id => @news
      end
    end
  end

  def destroy
    News.destroy(params[:id])
    flash[:notice] = "L'annuncio &egrave; stato cancellato"
    redirect_to :action => :index
  end
  
  def uptime
    render :text => "success"
  end
end
