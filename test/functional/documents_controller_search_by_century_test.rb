require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerSearchByCenturyTest < Test::Unit::TestCase
#  fixtures :documents, :authors, :responsibilities, :publishers_emblems

  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    Document.delete_all
    Document.create!(:title => "seicento I", :century => "17")
    Document.create!(:title => "seicento II", :century => "17")
    Document.create!(:title => "no century")
    Document.create!(:title => "settecento", :century => 18)
  end

  def test_search_by_century_alone
    get :secolo, :secolo => "XVII"
    assert_equal ["seicento I", "seicento II"], assigns(:documents).map(&:title)
    assert_equal "Secolo XVII: 2 schede", assigns(:page_title)
  end

  def test_secolo_query
    get :secolo
    assert_response :success
    assert_select "form[method='get']"
    assert_equal "Ricerca per secolo", assigns(:page_title)
  end
  
  def test_century_to_roman
    assert_equal "foo", @controller.send(:century_to_roman, "foo")
    assert_equal "XV", @controller.send(:century_to_roman, 15)
  end
  
  def test_roman_to_decimal
    assert_equal 15, @controller.send(:roman_to_decimal, "XV")
  end
  
end
