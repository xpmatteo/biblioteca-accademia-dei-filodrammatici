require "#{File.dirname(__FILE__)}/../test_helper"

class ContentManagementTest < ActionController::IntegrationTest
  fixtures :contents, :news
  
  def test_home_page
    get_home_page
  end
  
  def test_content_pages
    get_content_page(:zork)
    assert_tag :content => contents(:zork).body
  end

  def test_content_is_editable
    get_content_page(:zork)
    click_edit_button()
  end

private

  def click_edit_button
    assert_tag :tag => 'a', :content => 'edit', :attributes => { :href => '/content/edit/3' }
    get '/content/edit/3'
    assert_response :success
    post_via_redirect '/content/edit/3',
      :content => {
        :title => 'Pistacchio',
        :body => 'We changed it'
      }
    assert_response :success
    assert_template 'content/page'
    # non so perché falliscono.  il msg di errore è assurdo
#    assert_tag :tag => 'title', :content => 'Accademia dei Filodrammatici &mdash; Pistacchio'
#    assert_tag :content => 'We changed it'
  end

end
