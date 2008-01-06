require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerSearchByCenturyTest < Test::Unit::TestCase

  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    Document.delete_all
    Document.create!(:title => "seicento primo", :century => "17")
    Document.create!(:title => "seicento secondo", :century => "17")
    Document.create!(:title => "no century")
    Document.create!(:title => "settecento", :century => 18)
  end

  def test_search_form
    get :search
    assert_response :success
    assert_template 'documents/search'
    assert_equal 'Ricerca completa', assigns(:page_title), "titolo sbagliato"
    assert_select "form[method='get']"
    assert_nil assigns(:documents), "non deve assegnare a @documents"
  end  

  def test_search_by_century_alone
    get :search
    submit_form :century => "XVII"
    assert_equal ["seicento primo", "seicento secondo"], assigns(:documents).map(&:title)
    assert_equal "Ricerca completa: 2 schede", assigns(:page_title)
  end

  def test_search_by_century_and_keywords
    get :search
    submit_form do |form|
      form.century = "XVII"
      form.keywords = 'secondo'
    end    
    assert_equal ["seicento secondo"], assigns(:documents).map(&:title)
    assert_equal "Ricerca completa: una scheda", assigns(:page_title)
  end

  def test_search_by_keywords
    get :search
    submit_form do |form|
      form.keywords = 'secondo'
    end    
    assert_equal ["seicento secondo"], assigns(:documents).map(&:title)
    assert_equal "Ricerca completa: una scheda", assigns(:page_title)
  end

end