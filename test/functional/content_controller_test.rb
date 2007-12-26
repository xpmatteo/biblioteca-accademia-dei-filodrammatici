require File.dirname(__FILE__) + '/../test_helper'
require 'content_controller'

# Re-raise errors caught by the controller.
class ContentController; def rescue_action(e) raise e end; end

class ContentControllerTest < Test::Unit::TestCase
  fixtures :contents
  
  def setup
    @controller = ContentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    setup_fixture_files
  end

  def tear_down
    teardown_fixture_files
  end

  def test_index
    get 'index'
    assert_response :success
    assert_equal contents(:welcome), assigns(:content)
    assert_tag :content => /Welcome, my friends/
  end
  
  def test_link_to_edit_is_not_present_unless_authenticated
    get :page, :name => Content.find(1).name
    assert_response :success
    assert_no_tag :tag => 'a', :attributes => { :href => '/content/edit/1' }

    get_authenticated :page, :name => Content.find(1).name
    assert_response :success
    assert_tag :tag => 'a', :attributes => { :href => '/content/edit/1' }
  end
  
  def test_edit_is_protected
    get :edit, :id => 2
    assert_redirected_to :controller => 'login'
    
    old_content = Content.find(2)
    post :edit, :id => 2, :content => {
      :title => 'Perbacco!',
      :body => 'Ciumbia.'
    }
    assert_redirected_to :controller => 'login'
    assert_unchanged old_content
  end
  
  def test_page_foobar
    get 'page', :name => 'foobar'
    assert_response :success
  end
  
  def test_page_nonexistent
    get 'page', :name => 'nonexistent'
    assert_response 404
  end
  
  def test_get_edit
    get_authenticated :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:content)
    assert assigns(:content).valid?
    assert_equal Content.find(1), assigns(:content)
    assert_tag :content => "Modifica contenuto di 'welcome'"
    assert_tag :tag => 'form', :attributes => { :action => '/content/edit/1', :method => 'post' }
  end
  
  def test_update
    old_content = Content.find(2)
    post_authenticated :edit, :id => 2, :content => {
      :title => 'Perbacco!',
      :body => 'Ciumbia.'
    }
    assert_redirected_to :action => 'page', :name => old_content.name
    updated_content = Content.find(2)
    assert_equal old_content.name, updated_content.name
    assert_equal 'Perbacco!', updated_content.title
    assert_equal 'Ciumbia.',  updated_content.body
  end
  
  def test_update_with_pic
    old_content = Content.find(2)
    assert_nil old_content.image
    
    post_authenticated :edit, :id => 2, :content => {
      :image => upload(Test::Unit::TestCase.fixture_path + '/files/animal.jpg', 'image/jpg'),
      :title => 'Perbacco!',
      :body => 'Ciumbia.'
    }
    
    assert_redirected_to :action => 'page', :name => old_content.name
    updated_content = Content.find(2)
    assert_not_nil updated_content.image, "non ha caricato l'immagine"
    assert_equal '2/animal.jpg', updated_content.image_relative_path
  end
  
  def test_bad_update
    old_content = Content.find(2)
    post_authenticated :edit, :id => 2, :content => {
      :title => '',
      :body => 'Ciumbia.'
    }
    assert_response :success
    assert_tag :content => "Title can't be blank"
    assert_unchanged old_content
  end     

private
  def assert_unchanged(content)
    assert_equal Content.find(content.id), content
  end
end
