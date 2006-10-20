class DocumentsController < ApplicationController
  def index
    @content = Content.find_by_name("biblio") || Content.new(:body => "", :name => "biblio")
  end
  
  def authors
    @authors = Author.find(:all, :order => 'name', :conditions => ['upper(left(name, 1)) = upper(?)', params[:initial]])
  end
  
  def author
    @author = Author.find(params[:id])
    documents = @author.documents.sort {|a,b| a.title_after_asterisk <=> b.title_after_asterisk}
    @document_pages, @documents = paginate_collection documents, params
    render :template => 'documents/list'
  end
  
  def show
    @document = Document.find(params[:id])
  end
  
private

  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end

end
