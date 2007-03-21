require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerTest < Test::Unit::TestCase
  fixtures :documents, :authors, :responsibilities, :publishers_emblems
  
  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_tag :tag => 'a', :content => 'M', :attributes => { :href => '/biblio/autori/M' }
  end

  def test_authors_by_initial
    get :authors, :initial => 'M'
    assert_response :success
    assert_equal [authors(:mandosio_prospero), authors(:mor_carlo)], assigns(:authors)
    assert_template 'authors'    
    assert_tag :tag => 'a', :content => authors(:mor_carlo).name, :attributes => { :href => '/biblio/autore/' + authors(:mor_carlo).id.to_s }
  end
  
  def test_author_by_id
    get :author, :id => authors(:mor_carlo).id
    assert_response :success
    assert_equal 'Mor, Carlo A.: una scheda', assigns(:page_title)
    assert_template 'list'
    
    doc = authors(:mor_carlo).documents[0]
    assert_tag :content => doc.title
  end
  
  def test_author_name_escapes_html_entities
    assert Author.new(:name => 'Pippis Khan <1000-1100>', :id_sbn => 'yyy').save, "non ha salvato"
    get :authors, :initial => 'P'
    assert_tag :tag => 'a', :content => 'Pippis Khan &lt;1000-1100&gt;'
  end
  
  def test_author_books
    get :author, :id => authors(:mor_carlo).id
    doc = documents(:logica_umana)
    assert_response :success
    assert_tag :content => doc.title, :attributes => { :class => 'document-title' }
    assert_select ".document-author",      :text => doc.author.name
#    assert_select ".document-names",       :text => doc.names[0].name
    assert_select ".document-publication", :text => doc.publication
  end
  
  def test_book_with_no_author
    get :author, :id => authors(:praz_mario).id
    doc = documents(:teatro_elisabettiano)
    assert_response :success
    assert_tag :content => doc.title, :attributes => { :class => 'document-title' }
    assert_no_tag :attributes => { :class => 'document-author' }
    assert_select ".document-names", :text => /#{doc.names[0].name}\s*;\s+#{doc.names[1].name}/
  end
  
  def test_find_by_keywords
    get :find, :q => "logica"
    assert_response :success
    assert_template 'documents/list'
    assert_equal 'Ricerca "logica": un risultato', assigns(:page_title)
    assert_equal [documents(:logica_umana)], assigns(:documents)
  end
  
  def test_find_by_keywords_nothing
    get :find, :q => "lkjdhflkjhd"
    assert_response :success
    assert_template 'documents/list'
    assert_equal [], assigns(:documents)
  end
  
  def test_title_is_escaped
    get :find, :q => "<zot>"
    assert_response :success
    assert_template 'documents/list'
    assert_nil @response.body.index("<zot>"), "deve convertire i caratteri html in entita"    
  end
  
  def test_show_single_document
    doc = documents(:logica_umana)
    get :show, :id => doc.id
    assert_response :success
    assert_equal [doc], assigns(:documents), "non ha assegnato"
    assert_equal doc.title, assigns(:page_title), "titolo sbagliato"
    assert_template 'documents/list', "template sbagliato"
  end
  
  def test_search_by_collection
    get :collection, :name => "foo bar"
    assert_response :success
    assert_template 'documents/list', "template sbagliato"
    assert_equal [documents(:in_collection_foo_bar)], assigns(:documents), "non ha assegnato"
    assert_equal 'Collezione "foo bar": una scheda', assigns(:page_title)
  end
  
  def test_should_escape_html_in_title
    get :collection, :name => "<script>"
    assert_select "h3", :text => "Collezione &quot;&lt;script&gt;&quot;: nessuna scheda"
  end
  
  def test_query_by_year
    get :year, :year => 1936
    assert_response :success
    assert_template 'documents/list'
    assert_equal [documents(:anno_1936)], assigns(:documents), "assegnato i doc sbagliati"
    assert_equal 'Anno 1936: una scheda', assigns(:page_title), "titolo sbagliato"
  end
  
  def test_query_by_publishers_emblem
    get :publishers_emblem, :id => 1
    assert_response :success
    assert_template 'documents/list'
    assert_equal 'Marca "Un leone rampante": una scheda', assigns(:page_title), "titolo sbagliato"
    assert_equal ["Nell'anno 1802"], assigns(:documents).map {|d| d.title}, "assegnato i doc sbagliati"
  end  

  def test_create_child_document
    parent = documents(:logica_umana)
    assert_equal [], parent.children
    
    post_authenticated :create, :parent_id => parent, :document => { :title => 'Fooz', :id_sbn => 'xyz' }
    assert_equal [], assigns(:document).errors.full_messages
    
    parent.reload
    assert_equal 1, parent.children.count
    child = parent.children[0]
    assert_not_nil child, "come mai il figlio e' nil?"
    assert_redirected_to :action => :show, :id => child.id
  end
  
  def test_destroy_document
    document = documents(:logica_umana)
    get_authenticated :destroy, :id => document
    assert_redirected_to :action => :list
    
    post_authenticated :destroy, :id => document
    assert_redirected_to :action => :index
    assert_nil Document.find(:first, :conditions => ['id = ?', document.id] )
  end  
end
