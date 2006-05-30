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
    assert_tag :tag => 'style', :content => %r{url\(./upload/foo.gif.\)}
    assert_tag :content => /Welcome, my friends/
  end
  
  def test_page_foobar
    get 'page', :name => 'foobar'
    assert_response :success
    assert_tag :tag => 'style', :content => %r{url\(./upload/bar.gif.\)}
  end
  
  def test_content_body_is_textilized
    test_page_foobar
    assert_tag :tag => 'strong', :content => 'baz'
  end
  
  def test_page_nonexistent
    get 'page', :name => 'nonexistent'
    assert_redirected_to '/404.html'
  end
end
