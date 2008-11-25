class DocumentsController < ApplicationController
  scaffold :document

  before_filter :check_user_is_admin, 
    :except => [ :index, :list, :find, :show, :author, :authors, 
                 :collection, :year, :publishers_emblem, :secolo, :search ]

  verify :method => :post, 
    :only => [ :destroy, :create, :update ],
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
    @documents = Document.paginate(:author_id => author.id, :page => params[:page])
    @page_title = author.name + ": " + pluralize_schede
    render :template => 'documents/list'
  end

  def find
    @documents = Document.paginate(params)
    @page_title = "Ricerca \"#{params[:q]}\": " + pluralize(@documents.total_entries, "risultato", "risultati")
    render :template => 'documents/list'
  end
  
  def show
    document = Document.find(params[:id])
    @page_title = document.title_without_asterisk
    @documents = singleton_collection(document)
    render :template => 'documents/list'
  end
  
  def collection
    @documents = Document.paginate(:collection_name => params[:name])
    @page_title = 'Collezione "' + params[:name] + '": ' + pluralize_schede
    render :template => 'documents/list'
  end
  
  def year
    @documents = Document.paginate(:year => params[:year])
    @page_title = 'Anno ' + params[:year] + ': ' + pluralize_schede
    render :template => 'documents/list'
  end
  
  def publishers_emblem
    emblem = PublishersEmblem.find(params[:id])
    @documents = Document.paginate(:publishers_emblem_id => params[:id])
    @page_title = 'Marca "' + emblem.description + '": ' + pluralize_schede
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
  
  def search
    @documents = Document.paginate(params)
    if @documents
      @page_title = 'Ricerca completa: ' + pluralize_schede
    else
      @page_title = "Ricerca completa"
    end
  end

private

  def pluralize_schede(count=@documents.total_entries)
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
  
  def singleton_collection(document)
    WillPaginate::Collection.create(1, 10) { |pager| pager.replace [document] }
  end
end
