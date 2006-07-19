require "#{File.dirname(__FILE__)}/../test_helper"

class NewsAcceptanceTest < ActionController::IntegrationTest
  fixtures :news

  def test_news_titles_are_on_home_page
    get_home_page
    assert_page_contains_news_titles 'Prima notizia', 'Seconda notizia'
  end
  
  def test_can_create_news
    get_home_page
    click_insert_news_link
    assert_page_contains_form_with_controls 'title', 'body'
    edit_news { :title => 'Bah', :body => 'Bla' }
    assert_equal 3, News.count
    new_news = News.find_by_title('Bah')
    assert_equal 'Bla', new_news.body
  end
  
  def test_news_titles_are_links_to_news_pages
    get_home_page
    click_link_with_title 'Prima notizia'
    assert_page_contains_news news(:first)
  end
  
  def test_news_are_editable
    get_news_page news(:first)
    click_edit_news_link
    assert_page_contains_form_with_controls 'title', 'body'
    edit_news { :title => 'Foobar', :body => 'Bar baz baz' }    
    updated_news = News.find(news(:first).id)
    assert_page_contains_news updated_news
  end
  
  def test_news_are_deletable
    get_news_page news(:first)
    click_delete_news_link
    
    assert_page_contains_form_with_controls 'title', 'body'
    edit_news { :title => 'Foobar', :body => 'Bar baz baz' }    
    updated_news = News.find(news(:first).id)
    assert_page_contains_news updated_news
  end
end
