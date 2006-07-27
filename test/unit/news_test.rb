require File.dirname(__FILE__) + '/../test_helper'

class NewsTest < Test::Unit::TestCase
  fixtures :news

  def test_body_cant_be_blank
    n = News.new(:title => 'Foo')
    assert_false n.save, "body blank"
  end
  
  def test_title_cant_be_blank
    n = News.new(:body => 'Bar')
    assert_false n.save, "title blank"
  end
end
