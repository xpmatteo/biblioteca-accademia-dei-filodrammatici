require File.dirname(__FILE__) + '/../test_helper'

class AuthorTest < Test::Unit::TestCase
  fixtures :authors, :documents, :marc_fields

  def test_validation
    assert       Author.new(:name => 'Foo', :id_sbn => 'bar').save
    assert_false Author.new(:name => 'Foo').save
    assert_false Author.new(:id_sbn => 'bar').save
    assert_false Author.new.save
  end
  
  def test_initials
    assert_equal ['B', 'M', 'P'], Author.initials
  end
  
  def test_documents_as_author
    a = authors(:mor_carlo)
    assert_equal 1, a.documents.size
    assert_starts_with 'Logica umana', a.documents[0].title
  end

  def test_documents_as_less_important_author
    a = authors(:praz_mario)
    assert_equal 1, a.documents.size
    assert_starts_with 'Teatro elisabettiano', a.documents[0].title
  end

private
  def assert_starts_with(expected, actual, message=nil)
    assert_equal expected, actual[0, expected.length], message
  end
end
