class MenuItemsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @menu_items = MenuItem.find(:all, :order => 'parent_id, position')
  end

  def show
    @menu_item = MenuItem.find(params[:id])
  end

  def new
    @menu_item = MenuItem.new
  end

  def create
    @menu_item = MenuItem.new(params[:menu_item])
    if @menu_item.save
      flash[:notice] = 'MenuItem was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @menu_item = MenuItem.find(params[:id])
  end

  def update
    @menu_item = MenuItem.find(params[:id])
    if @menu_item.update_attributes(params[:menu_item])
      flash[:notice] = 'MenuItem was successfully updated.'
      redirect_to :action => 'show', :id => @menu_item
    else
      render :action => 'edit'
    end
  end

  def destroy
    MenuItem.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
