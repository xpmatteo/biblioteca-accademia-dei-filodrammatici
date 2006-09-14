require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerTest < Test::Unit::TestCase
  fixtures :documents, :authors
  
  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_tag :tag => 'a', :content => 'H', :attributes => { :href => '/biblio/autori/H' }
  end

  def test_authors_by_initial
    get :authors, :initial => 'H'
    assert_response :success
    assert_equal [authors(:hemingway)], assigns(:authors)
    assert_template 'authors'    
    assert_tag :tag => 'a', :content => authors(:hemingway).name, :attributes => { :href => '/biblio/autore/1' }
  end
  
  def test_author_by_id
    get :author, :id => 1
    assert_response :success
    assert_equal authors(:hemingway), assigns(:author)
    assert_template 'list'
    
    doc = authors(:hemingway).documents[0]
    assert_tag :tag => 'a', :content => doc.title, :attributes => { :href => '/biblio/libro/' + doc.id.to_s }
  end
  
  def test_author_name_escapes_html_entities
    get :authors, :initial => 'M'
    assert_tag :tag => 'a', :content => 'Monti, Vincenzo &lt;1754-1828&gt;'
  end
end
