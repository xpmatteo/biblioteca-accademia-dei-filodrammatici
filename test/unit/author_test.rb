require File.dirname(__FILE__) + '/../test_helper'

class AuthorTest < Test::Unit::TestCase
  fixtures :authors, :documents, :authorships, :marc_fields

  def test_validation
    assert       Author.new(:name => 'Foo', :id_sbn => 'bar').save
    assert_false Author.new(:name => 'Foo').save
    assert_false Author.new(:id_sbn => 'bar').save
    assert_false Author.new.save
  end
  
  def test_initials
    assert_equal ['M', 'P'], Author.initials
  end
  
  def test_documents_sort_ignores_article
    # TODO restaurare
#    assert_equal ['Per chi suona la campana', 'Il vecchio e il mare'], authors(:hemingway).documents.map{|d| d.title}
  end
  
  def test_documents
    a = authors(:mor_carlo)
    assert_equal 1, a.documents.count
    assert_equal 'Logica umana', a.documents[0].title[0, 12]
  end

end
