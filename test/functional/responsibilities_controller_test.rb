require File.dirname(__FILE__) + '/../test_helper'
require 'responsibilities_controller'

# Re-raise errors caught by the controller.
class ResponsibilitiesController; def rescue_action(e) raise e end; end

class ResponsibilitiesControllerTest < Test::Unit::TestCase
  fixtures :documents, :authors, :responsibilities

  self.use_transactional_fixtures = false  

  def setup
    @controller = ResponsibilitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @document   = documents(:teatro_elisabettiano)
    @praz       = responsibilities(:praz_curatore_di_teatro_elisabettiano)
    @baldini    = responsibilities(:baldini_curatore_di_teatro_elisabettiano)
    @mor        = authors(:mor_carlo)
  end

  # Replace this with your real tests.
  def test_list
    get :list, :document_id => @document.id
    assert_response :success
    assert_template "list"

    assert_select 'table#responsibilities' do
      assert_select "tr", 2
      assert_select "tr > td", "Praz, Mario"
      assert_select "tr > td", "Baldini, Gabriele"
    end
  end
  
  def test_destroy_does_not_accept_get
    get_authenticated :destroy, :id => @praz.id
    assert_response :redirect
    assert_not_deleted @praz
  end
  
  def test_destroy_requires_authentication
    post :destroy, :id => @praz.id
    assert_response :redirect
    assert_not_deleted @praz
  end
  
  def test_destroy
    post_authenticated :destroy, :id => @praz.id
    assert_redirected_to :action => 'list', :document_id => @document.id
    assert_deleted @praz
  end
  
  def test_create    
    assert_false is_responsible(@mor, @document)
    
    post_authenticated :create, params_for_create
    assert_redirected_to :action => 'list', :document_id => @document.id

    assert is_responsible(@mor, @document)
  end
  
  def test_create_requires_authentication
    post :create, params_for_create
    assert_response :redirect
    assert_false is_responsible(@mor, @document)
  end

  def test_create_does_not_accept_get
    get_authenticated :create, params_for_create
    assert_response :redirect
    assert_false is_responsible(@mor, @document)
  end
  
  private
  
  def params_for_create
    {:author_id => @mor, :document_id => @document}
  end
  
  def assert_deleted(responsibility)
    assert_nil Responsibility.find_by_id(responsibility.id), "responsibility was not deleted"
  end

  def assert_not_deleted(responsibility)
    assert_not_nil Responsibility.find_by_id(responsibility.id), "responsibility was deleted"
  end
  
  def is_responsible(author, document)
    @document.reload
    document.names.member? author
  end
    
end
