require File.dirname(__FILE__) + '/../test_helper'

class AuthorTest < Test::Unit::TestCase
  fixtures :authors, :documents, :responsibilities

  def test_validation
    assert       Author.new(:name => 'Foo', :id_sbn => 'bar').save
    assert_false Author.new(:id_sbn => 'bar').save
    assert_false Author.new.save
  end
  
  def test_validates_uniqueness_of_id_sbn_should_allow_nil
    a = Author.create(:name => "Pippo", :id_sbn => "")
    assert_valid a
    b = Author.new(:name => "Pluto", :id_sbn => "")
    assert_valid b
  end

  def test_initials
    assert_equal ['B', 'M', 'P'], Author.initials
  end
  
  def test_documents_as_author
    a = authors(:mor_carlo)
    assert_equal 1, a.documents.size
    assert_equal 'Logica umana', a.documents[0].title
  end

  def test_documents_as_less_important_author
    a = authors(:praz_mario)
    assert_equal 1, a.documents.size
    assert_equal 'Teatro Elisabettiano', a.documents[0].title
  end
  
end
