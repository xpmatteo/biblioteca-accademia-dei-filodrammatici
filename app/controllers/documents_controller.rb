class DocumentsController < ApplicationController
  def index
  end
  
  def authors
    @authors = Author.find(:all, :order => 'name', :conditions => ['upper(left(name, 1)) = upper(?)', params[:initial]])
  end
  
  def author
    @author = Author.find(params[:id])
    render :template => 'documents/list'
  end
end
