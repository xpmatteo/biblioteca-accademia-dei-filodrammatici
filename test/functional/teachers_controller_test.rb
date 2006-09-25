require File.dirname(__FILE__) + '/../test_helper'
require 'teachers_controller'

# Re-raise errors caught by the controller.
class TeachersController; def rescue_action(e) raise e end; end

class TeachersControllerTest < Test::Unit::TestCase
  fixtures :teachers, :menu_items

  def setup
    @controller = TeachersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:teachers)
    assert_equal [teachers(:gatto)], assigns(:teachers)
    assert_not_nil assigns(:teachers_seminar), 'non ha assegnato i docenti dei seminari'
    assert_equal [teachers(:clough)], assigns(:teachers_seminar)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:teacher)
    assert assigns(:teacher).valid?
  end

  def test_new
    get_authenticated :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:teacher)
  end

  def test_create
    num_teachers = Teacher.count

    post_authenticated :create, :teacher => {
        :first_name => 'Gino',
        :last_name => 'Ginotti',
    }

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_teachers + 1, Teacher.count
  end

  def test_create_with_image
    num_teachers = Teacher.count

    post_authenticated :create, :teacher => {
        :first_name => 'Pino',
        :last_name => 'Pinotti',
        :image => fake_upload,
    }

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_teachers + 1, Teacher.count
  end

  def test_edit
    get_authenticated :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:teacher)
    assert assigns(:teacher).valid?
  end

  def test_update
    post_authenticated :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end
  
  def test_update_with_image
    old_teacher = Teacher.find(2)
    assert_nil old_teacher.image
    
    post_authenticated :update, :id => 2, :teacher => {
      :image => fake_upload,
    }
    
    assert_redirected_to :action => 'show', :id => 2
    updated_teacher = Teacher.find(2)
    assert_not_nil updated_teacher.image, "non ha caricato l'immagine"
    assert_equal '2/animal.jpg', updated_teacher.image_relative_path
  end

  def test_destroy
    assert_not_nil Teacher.find(1)

    post_authenticated :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Teacher.find(1)
    }
  end
  
  def test_protection
    assert_modifications_are_protected
  end
  
end
