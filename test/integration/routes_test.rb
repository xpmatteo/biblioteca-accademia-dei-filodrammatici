require "#{File.dirname(__FILE__)}/../test_helper"

class RoutesTest < ActionController::IntegrationTest
  # fixtures :your, :models

  def test_main_menu_contains_link_docenti
    get_home_page
    assert_tag :tag => 'a', :attributes => { :href => '/docenti' }
  end
  
  def test_link_docenti
    get '/docenti'
    assert_response :success    
  end
  
  def test_home_page_contains_link_to_login
    get_home_page
    assert_tag :tag => 'a', :attributes => { :href => '/login' }
  end
  
  def test_login_link
    get '/login'
    assert_response :success
    assert_template 'login/login'
  end
  
  def test_biblio
    get '/biblio'
    assert_response :success
    assert_template 'documents/index'

    get '/biblio/index'
    assert_response :success
    assert_template 'documents/index'
    
    get '/biblio/iniziali/M'
    assert_response :success
    assert_template 'documents/index'
  end
end
