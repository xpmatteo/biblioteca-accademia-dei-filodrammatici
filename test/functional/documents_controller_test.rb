require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerTest < Test::Unit::TestCase
  fixtures :documents, :authors, :authorships, :marc_fields, :marc_subfields, :menu_items
  
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
    assert_equal authors(:mor_carlo), assigns(:author)
    assert_template 'list'
    
    doc = authors(:mor_carlo).documents[0]
    assert_tag :content => doc.title
  end
  
  def test_author_name_escapes_html_entities
    assert Author.new(:name => 'Pippis Khan <1000-1100>', :id_sbn => 'yyy').save, "non ha salvato"
    get :authors, :initial => 'P'
    assert_tag :tag => 'a', :content => 'Pippis Khan &lt;1000-1100&gt;'
  end
  
  def test_show
    doc = documents(:logica_umana)
    get :show, :id => doc.id
    assert_response :success
    assert_equal doc, assigns(:document)
    assert_tag :content => doc.title, :attributes => { :class => 'document-title' }
    assert_tag :content => doc.authors[0].name, :attributes => { :class => 'document-authors' }
    assert_tag :content => doc.publication, :attributes => { :class => 'document-publication' }
  end
end
