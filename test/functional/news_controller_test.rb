require File.dirname(__FILE__) + '/../test_helper'
require 'news_controller'

# Re-raise errors caught by the controller.
class NewsController; def rescue_action(e) raise e end; end

class NewsControllerTest < Test::Unit::TestCase
  def setup
    @controller = NewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_get_news
    get 'new'
    assert_response :success
    assert_not_nil assigns(:news)
    assert_tag :tag => 'form', :attributes => { :action => '/news/new', :method => 'post' }    
  end
  
  def test_post_news
    post 'new', :news => { :title => 'Pippo', :body => 'Ueila ueila' }
    new_news = News.find_by_title('Pippo')
    assert_not_nil new_news, 'non ha inserito la notizia'
    assert_equal 'Ueila ueila', new_news.body
    assert_redirected_to :action => 'show', :id => new_news.id
  end

  def test_post_news_with_errors 
    post 'new', :news => { :title => 'Foo', :body => ''}

    assert_response :success
    assert_tag :content => "Body can't be blank"
    assert_not_nil assigns(:news), 'should assign news'
    assert_equal 'Foo', assigns(:news).title
  end
end
