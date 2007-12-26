class DocumentsController < ApplicationController
  scaffold :document
  before_filter :check_user_is_admin, :except => [ :index, :list, :find, :show, :author, :authors, :collection, :year, :publishers_emblem, :secolo ]
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :index }

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
    documents = Document.prune_children(author.documents)
    paginate_documents documents
    @page_title = author.name + ": " + pluralize_schede(documents.size)
    render :template => 'documents/list'
  end

  def find
    documents = Document.prune_children(Document.find_by_keywords(params[:q]))
    @page_title = "Ricerca \"#{params[:q]}\": " + pluralize(documents.size, "risultato", "risultati")
    paginate_documents documents
    render :template => 'documents/list'
  end
  
  def show
    document = Document.find(params[:id])
    @page_title = document.title_without_asterisk
    paginate_documents [document]
    render :template => 'documents/list'
  end
  
  def collection
    documents = find_documents(:collection_name, params[:name])
    @page_title = 'Collezione "' + params[:name] + '": ' + pluralize_schede(documents.size)
    paginate_documents documents
    render :template => 'documents/list'
  end
  
  def year
    documents = find_documents(:year, params[:year])
    paginate_documents documents
    @page_title = 'Anno ' + params[:year] + ': ' + pluralize_schede(documents.size)
    render :template => 'documents/list'
  end
  
  def secolo
    @centuries = %w(XVI XVII XVIII XIX XX XXI)
    @page_title = "Ricerca per secolo"
    if params[:secolo]
      if params[:q].blank?
        documents = find_documents(:century, RomanNumerals.roman_to_decimal(params[:secolo]))
      else
        documents = Document.find_by_keywords(params[:q], "century = #{RomanNumerals.roman_to_decimal(params[:secolo])}")
        Document.prune_children(documents)
      end
      @page_title = 'Secolo ' + RomanNumerals.decimal_to_roman(params[:secolo]) + ': ' + pluralize_schede(documents.size)
      paginate_documents documents
    end
  end
  
  def publishers_emblem
    emblem = PublishersEmblem.find(params[:id])
    documents = find_documents(:publishers_emblem_id, params[:id])
    paginate_documents documents
    @page_title = 'Marca "' + emblem.description + '": ' + pluralize_schede(documents.size)
    render :template => 'documents/list'
  end
  
  def create
    @document = Document.new(params[:document])
    if params[:parent_id]
      parent = Document.find(params[:parent_id])
      parent.children << @document
    end
    if @document.save
      flash[:notice] = 'Il documento &grave; stato creato.'
      puts @document
      redirect_to :action => 'show', :id => @document
    else
      render :action => 'new'
    end
  end
    
  def destroy
    Document.destroy(params[:id])
    flash[:notice] = "La scheda &egrave; stata cancellata"
    redirect_to :action => :index
  end

private

  def find_documents(col, val)
    docs = Document.find(:all, :conditions => ["#{col.to_s} = ?", val], :order => Document::CANONICAL_ORDER)
    Document.prune_children(docs)
  end

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
  
  def pluralize_schede(count)
    pluralize(count, "scheda", "schede", :feminine => true)
  end

  def pluralize(count, singular, plural, options={})
    case count
    when 0
      if options[:feminine]
        "nessuna " + singular
      else
        "nessun " + singular
      end
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
