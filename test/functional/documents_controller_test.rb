require File.dirname(__FILE__) + '/../test_helper'
require 'documents_controller'

# Re-raise errors caught by the controller.
class DocumentsController; def rescue_action(e) raise e end; end

class DocumentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = DocumentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Document.delete_all
    Document.import_unimarc File.dirname(__FILE__) + '/../fixtures/dump_books.xml'
  end

  def test_index
    get :index
    assert_response :success
    assert_equal ['M', 'P'], assigns(:author_initials)
    assert_tag :tag => 'a', :content => 'M', :attributes => { :href => '/biblio/iniziali/M' }
  end
  
end
