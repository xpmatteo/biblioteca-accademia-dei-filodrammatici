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
  end

  def test_index
    get 'index'
    assert_response :success
    assert_equal contents(:welcome), assigns(:content)
    assert_tag :content => /Welcome, my friends/
  end
  
  def test_page_foobar
    get 'page', :name => 'foobar'
    assert_response :success
  end
  
  def test_content_body_is_textilized
    test_page_foobar
    assert_tag :tag => 'strong', :content => 'baz'
  end
  
  def test_page_nonexistent
    get 'page', :name => 'nonexistent'
    assert_redirected_to '/404.html'
  end
  
  def test_edit_button
    get 'page', :name => 'foobar'
    assert_response :success
    assert_tag :tag => 'a', :attributes => { :href => '/content/edit/2' }
  end
  
  def test_get_edit
    get :edit, :id => 1

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
    post :edit, :id => 2, :content => {
      :title => 'Perbacco!',
      :body => 'Ciumbia.'
    }
    assert_redirected_to :action => 'page', :name => old_content.name
    updated_content = Content.find(2)
    assert_equal old_content.name, updated_content.name
    assert_equal 'Perbacco!', updated_content.title
    assert_equal 'Ciumbia.',  updated_content.body
  end
  
  def test_bad_update
    old_content = Content.find(2)
    post :edit, :id => 2, :content => {
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
