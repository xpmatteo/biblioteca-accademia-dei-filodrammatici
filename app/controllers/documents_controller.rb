class DocumentsController < ApplicationController
  scaffold :document
  before_filter :check_user_is_admin, :except => [ :index, :list, :find, :show, :author, :authors ]

  def index
    @content = Content.find_by_name("biblioteca") || Content.new(:title => 'Biblioteca', :body => "Testo da modificare", :name => "biblioteca")
    @content.save if @content.new_record?
  end
  
  def authors
    @authors = Author.find(:all, :order => 'name', :conditions => ['upper(left(name, 1)) = upper(?)', params[:initial]])
    @page_title = "Iniziale '#{params[:initial]}': " + pluralize(@authors.size, "autore", "autori")
  end
  
  def author
    author = Author.find(params[:id])
    documents = author.documents
    paginate_documents documents
    @page_title = author.name + ": " + pluralize(documents.size, "scheda", "schede", :feminine => true)
    render :template => 'documents/list'
  end

  def find
    documents = Document.find_by_keywords(params[:q])
    @page_title = "Ricerca \"#{params[:q]}\": " + pluralize(documents.size, "risultato", "risultati")
    paginate_documents documents
    render :template => 'documents/list'
  end
  
  def show
    document = Document.find(params[:id])
    @page_title = document.title
    paginate_documents [document]
    render :template => 'documents/list'
  end
  
private

  def paginate_documents(documents)
    @document_pages, @documents = paginate_collection documents, :page => params[:page]
  end

  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options

    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end

  def pluralize(count, singular, plural, options={})
    case count
    when 0
      "nessun " + singular
    when 1
      if options[:feminine]
        "una " + singular
      else
        "un " + singular
      end
    else
      count.to_s + " " + plural
    end
  end
end
