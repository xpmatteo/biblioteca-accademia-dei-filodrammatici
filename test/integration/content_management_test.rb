require "#{File.dirname(__FILE__)}/../test_helper"

class ContentManagementTest < ActionController::IntegrationTest
  fixtures :contents, :menu_items

  def test_content_pages 
    get_content_page "welcome"
    get_content_page "foobar"
    get_content_page "zork"
  end                           
  
  def test_content_missing
     get "piciopacio"
     assert_response 404
  end

private

  def get_content_page(name)
    get name
    assert_response :success
    assert_template 'content/page'
  end

end
