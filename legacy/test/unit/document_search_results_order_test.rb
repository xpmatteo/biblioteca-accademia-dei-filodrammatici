require File.dirname(__FILE__) + '/../test_helper'

class DocumentSearchResultOrderTest < Test::Unit::TestCase  
  self.use_transactional_fixtures = false
  
  def setup
    Author.delete_all
    Document.delete_all
    abbondio = Author.create!(:name => "Abbondio, Don")
    patroclo = Author.create!(:name => "Patroclo")
    zuzzurellu = Author.create!(:name => "Zuzzurellu")
    Document.create!(:title => "aaa", :year => "1903", :author_id => abbondio.id)
    Document.create!(:title => "bbb", :year => "1902", :author_id => zuzzurellu.id)
    Document.create!(:title => "ccc", :year => "1901", :author_id => patroclo.id)
    Document.create!(:title => "ddd", :year => "1900")
  end

  def test_search_ordered_by_title
    assert_equal %w(aaa bbb ccc ddd), search(:century => "XX")
  end

  def test_search_ordered_by_author
    assert_equal %w(ddd aaa ccc bbb), search(:century => "XX", :order => "author")
  end

  def test_search_ordered_by_year
    assert_equal %w(ddd ccc bbb aaa), search(:century => "XX", :order => "year")
  end

  def test_search_ordered_by_nonsense_word
    assert_equal %w(aaa bbb ccc ddd), search(:century => "XX", :order => "foobar")
  end
  
  def test_century_and_nulls
    Document.delete_all
    Document.create!(:title => "b foo", :collection_name => "bla", :century => "16")
    Document.create!(:title => "c foo", :collection_name => "bla", :century => "17")
    Document.create!(:title => "d foo", :collection_name => "bla", :year => "1800")
    Document.create!(:title => "e foo", :collection_name => "bla", :century => "20")    
    Document.create!(:title => "a foo", :collection_name => "bla")
    assert_equal ["b foo", "c foo", "d foo", "e foo", "a foo"], search(:collection_name => "bla", :order => "year")
  end

private

  def search(options)
    documents = Document.paginate(options.merge(:page => "1"))
    documents.map(&:title) if documents
  end
end
