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

  def test_search_by_century_alone
    get :secolo, :secolo => "XVII"
    assert_equal ["seicento primo", "seicento secondo"], assigns(:documents).map(&:title)
    assert_equal "Secolo XVII: 2 schede", assigns(:page_title)
  end

  def test_find_by_keywords_and_other_condition
    10.times do |n| Document.create!(:title => "eccetera #{n}", :century => "19"); end
    
    assert_equal ["seicento primo", "seicento secondo"], Document.find_by_keywords("seicento").map(&:title)
    assert_equal ["seicento primo"], Document.find_by_keywords("seicento", "title like '%primo'").map(&:title)
  end
  
  def test_search_by_century_and_text
    get :secolo, :secolo => "XVII", :q => "secondo"
    assert_equal ["seicento secondo"], assigns(:documents).map(&:title)
    assert_equal "Secolo XVII: una scheda", assigns(:page_title)
  end

  def test_secolo_query
    get :secolo
    assert_response :success
    assert_select "form[method='get']"
    assert_equal "Ricerca per secolo", assigns(:page_title)
  end
  
end
