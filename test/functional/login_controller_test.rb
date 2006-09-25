require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Re-raise errors caught by the controller.
class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < Test::Unit::TestCase
  fixtures :menu_items
  
  def setup
    @controller = LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_login
    get :login
    assert_response :success
    assert_tag :tag => 'form'
    assert_tag :tag => 'input', :attributes => { :name => 'password', :type => 'password'}
  end
  
  def test_login_post_ok
    post :login, :password => LoginController::EXPECTED_PASSWORD
    assert_redirected_to :controller => 'news'
    assert session[:authenticated]
    assert_equal 'Benvenuto, amministratore', flash[:notice]
  end
  
  def test_login_failed
    post :login, :password => 'bogus'
    assert_response :success
    assert_false session[:authenticated]
    assert_equal 'Password errata', flash[:notice]
    assert_tag :content => flash[:notice]
  end
end
