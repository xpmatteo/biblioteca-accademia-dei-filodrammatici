require File.dirname(__FILE__) + '/../test_helper'
require 'authors_controller'

# Re-raise errors caught by the controller.
class AuthorsController; def rescue_action(e) raise e end; end

class AuthorsControllerTest < Test::Unit::TestCase
  fixtures :authors
  self.use_transactional_fixtures = false

  def setup
    @controller = AuthorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = authors(:mor_carlo).id
  end

  def test_index
    get_authenticated :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get_authenticated :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:authors)
  end

  def test_show
    get_authenticated :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:author)
    assert assigns(:author).valid?
  end

  def test_new
    get_authenticated :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:author)
  end

  def test_create
    num_authors = Author.count

    post_authenticated :create, :author => attributes_for_new_author
    assert_valid assigns(:author)
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_authors + 1, Author.count
  end

  def test_edit
    get_authenticated :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:author)
    assert assigns(:author).valid?
  end

  def test_update
    post_authenticated :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Author.find(@first_id)
    }

    post_authenticated :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Author.find(@first_id)
    }
  end

  private
  def attributes_for_new_author
    {:name => "Pippo de Pippis", :id_sbn => "abcde"}
  end
end
