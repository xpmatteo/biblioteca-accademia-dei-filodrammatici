require "#{File.dirname(__FILE__)}/../test_helper"

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :contents

  def test_welcome
    get '/'
    assert_response :success
    assert_tag :tag => 'title', :content => 'Accademia dei Filodrammatici'
  end
  
  def test_foobar_page
    get '/pagina/foobar'
    assert_response :success
    assert_tag :tag => 'title', :content => 'Accademia dei Filodrammatici &mdash; Foobar'
  end
  
  
end
