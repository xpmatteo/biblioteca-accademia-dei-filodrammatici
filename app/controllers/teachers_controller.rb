class TeachersController < ApplicationController
  uses_tiny_mce
  before_filter :check_user_is_admin, :except => [ :index, :list, :show ]

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def index
    list
    render :action => 'list'
  end

  def list
    @teachers         = Teacher.find(:all, :conditions => 'not for_seminar', :order => 'last_name')
    @teachers_seminar = Teacher.find(:all, :conditions => 'for_seminar',     :order => 'last_name')
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher])
    if @teacher.save
      flash[:notice] = 'Teacher was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])
    if @teacher.update_attributes(params[:teacher])
      flash[:notice] = 'Teacher was successfully updated.'
      redirect_to :action => 'show', :id => @teacher
    else
      render :action => 'edit'
    end
  end

  def destroy
    Teacher.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
