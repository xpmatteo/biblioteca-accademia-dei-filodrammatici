class ResponsibilitiesController < ApplicationController
  layout "documents"

  before_filter :check_user_is_admin, :except => [ :list ]
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :controller => :documents }

  def list
    @document = Document.find(params[:document_id])
  end
  
  def destroy
    unless request.post?
      redirect_to :controller => "documents" 
      return
    end
    
    @responsibility = Responsibility.find(params[:id])
    redirect_to :action => "list", :document_id => @responsibility.document_id
    @responsibility.destroy
  end
  
  def create
    @document = Document.find(params[:document_id])
    @author = Author.find(params[:author_id])
    @document.responsibilities.create!(:document_id => @document.id, :author_id => @author.id)
    redirect_to :action => "list", :document_id => @document
  end
end
