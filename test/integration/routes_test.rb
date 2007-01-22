require "#{File.dirname(__FILE__)}/../test_helper"

class RoutesTest < ActionController::IntegrationTest
  fixtures :menu_items, :documents

  def test_main_menu_contains_link_docenti
    get '/'
    assert_response :success    
    assert_tag :tag => 'a', :attributes => { :href => '/docenti' }
  end
  
  def test_link_docenti
    get '/docenti'
    assert_response :success    
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
    
    get '/biblio/autori/M'
    assert_response :success
    assert_template 'documents/authors'
    
    get '/biblio/scheda/146'
    assert_response :success
    assert_template 'documents/list'
    
    assert_equal "/biblio/scheda/146", 
      url_for(:controller => 'documents', :action => 'show', :id => 146, :only_path => true)
      
    assert_equal "/biblio/collezione/foo+bar", 
      url_for(:controller => 'documents', :action => 'collection', :name => 'foo bar', :only_path => true)
  end
  
private
  def get_home_page
    assert_response :success
    assert_tag :tag => 'title', :content => 'Accademia dei Filodrammatici'
  end
end
