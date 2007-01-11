require "#{File.dirname(__FILE__)}/../test_helper"

class NewsAcceptanceTest < ActionController::IntegrationTest
  fixtures :news

  def setup
    @values = {}
  end

  def test_news_titles_are_on_home_page
    get "/notizie"
    assert_page_contains_news_titles 'Prima notizia', 'Seconda notizia'
  end
  
private

  def assert_page_contains_news_titles(*titles)
    for title in titles
      assert_tag :content => title
    end
  end

end
