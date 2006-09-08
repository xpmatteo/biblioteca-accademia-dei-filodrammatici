class DocumentsController < ApplicationController
  def index
    @author_initials = Document.author_initials
  end
  
end
