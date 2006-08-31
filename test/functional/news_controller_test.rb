require File.dirname(__FILE__) + '/../test_helper'
require 'news_controller'

# Re-raise errors caught by the controller.
class NewsController; def rescue_action(e) raise e end; end

class NewsControllerTest < Test::Unit::TestCase
  fixtures :news
  
  def setup
    @controller = NewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_news
    get_authenticated 'new'
    assert_response :success
    assert_not_nil assigns(:news)
    assert_tag :tag => 'form', :attributes => { :action => '/news/new', :method => 'post' }    
  end
  
  def test_new_news
    post_authenticated 'new', :news => { :title => 'Pippo', :body => 'Ueila ueila' }
    new_news = News.find_by_title('Pippo')
    assert_not_nil new_news, 'non ha inserito la notizia'
    assert_equal 'Ueila ueila', new_news.body
    assert_redirected_to :action => :show, :id => new_news.id
  end

  def test_new_news_with_errors 
    post_authenticated 'new', :news => { :title => 'Foo', :body => ''}

    assert_response :success
    assert_tag :content => "Body can't be blank"
    assert_not_nil assigns(:news), 'should assign news'
    assert_equal 'Foo', assigns(:news).title
  end

  def test_edit_get
    get_authenticated :edit, :id => 1
    assert_response :success
    assert_equal news(:prima_notizia), assigns(:news)
  end

  def test_edit_post
    post_authenticated :edit, :id => 1, :news => { :title => 'Foo', :body => 'Bar'}
    assert_redirected_to :action => :show, :id => 1
    assert_equal "L'annuncio &egrave; stato modificato", flash[:notice]
    updated_news = News.find(1)
    assert_equal 'Foo', updated_news.title
    assert_equal 'Bar', updated_news.body
  end
  
  def test_edit_post_with_error
    post_authenticated :edit, :id => 1, :news => { :title => '', :body => 'Bar'}
    assert_response :success
    assert_equal '', assigns(:news).title
    assert_equal 'Bar', assigns(:news).body
  end
  
  def test_destroy_news
    get_authenticated :destroy, :id => 1
    assert_redirected_to :action => :index
    assert_equal news(:prima_notizia), News.find(1)
    
    post_authenticated :destroy, :id => 1
    assert_redirected_to :action => :index
    assert_nil News.find(:first, :conditions => 'id = 1')
  end
  
  def test_protection
    assert_protected :new
    assert_protected :edit
    assert_protected_post :destroy
  end
end
