require "#{File.dirname(__FILE__)}/../test_helper"
require "#{File.dirname(__FILE__)}/../../db/migrate/005_populate_content"

class ContentManagementTest < ActionController::IntegrationTest

  def setup
     PopulateContent.up
  end
  
  def test_home_page
    get_home_page
  end
  
  def test_content_pages 
    get_content_page "la-scuola"
    get_content_page "bando-2007"
    get_content_page "spazio-diplomati"
  end                           
  
  def test_content_missing
     get "pagina/piciopacio"
     assert_response 404
  end

private

  def get_content_page(name)
    get name
    assert_response :success
    assert_template 'content/page'
  end

end
