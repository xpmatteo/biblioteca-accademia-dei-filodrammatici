class GraduatesController < ApplicationController
  uses_tiny_mce

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    @content = Content.find_by_name('spazio-diplomati')
  end

  def list          
    @graduation_years = Graduate.graduation_years 
    @initials = Graduate.initials
    if params[:year]           
      conditions = ['graduation_year = ?', params[:year]]
    elsif params[:initial]
      conditions = ['upper(left(last_name, 1)) = ?', params[:initial]]
    else
      conditions = nil
    end
    @graduate_pages, @graduates = paginate :graduates, 
      :per_page => 100, 
      :conditions => conditions, 
      :order => 'last_name, first_name'
  end

  def show
    @graduate = Graduate.find(params[:id])
  end

  def new
    @graduate = Graduate.new
  end

  def create
    @graduate = Graduate.new(params[:graduate])
    if @graduate.save
      flash[:notice] = 'Graduate was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @graduate = Graduate.find(params[:id])
    render :layout => 'admin'
  end

  def update
    @graduate = Graduate.find(params[:id])
    if @graduate.update_attributes(params[:graduate])
      flash[:notice] = 'Graduate was successfully updated.'
      redirect_to :action => 'show', :id => @graduate
    else
      render :action => 'edit', :layout => 'admin'
    end
  end

  def destroy
    Graduate.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
