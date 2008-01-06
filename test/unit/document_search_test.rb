require File.dirname(__FILE__) + '/../test_helper'

class DocumentSearchTest < Test::Unit::TestCase
  fixtures :authors, :documents, :responsibilities
  
  def test_search_by_year_range
      Document.delete_all
      (1900..1910).each do |year|
        Document.create!(:title => "doc-#{year}", :year => year)
      end
      assert_equal [], search(:year_from => 2000)
      assert_equal [], search(:year_to => 1899)
      assert_equal %w(doc-1903), search(:year_from => 1903, :year_to => 1903)
      assert_equal %w(doc-1903 doc-1904 doc-1905), search(:year_from => 1903, :year_to => 1905)      
      assert_equal %w(doc-1900 doc-1901 doc-1902), search(:year_to => 1902)      
      assert_equal %w(doc-1908 doc-1909 doc-1910), search(:year_from => 1908)      
  end
  
  def test_search_by_nothing
    assert_equal nil, search({})
    assert_equal nil, search({:foo => "bar"})
  end

  def test_search_by_century
    Document.delete_all
    Document.create!(:title => "seicento I", :century => "17")
    Document.create!(:title => "seicento II", :century => "17")
    Document.create!(:title => "no century")
    Document.create!(:title => "settecento", :century => 18)
    assert_equal ["seicento I", "seicento II"], search(:century => "XVII")
    assert_equal ["settecento"], search(:century => "XVIII")
  end
  
  def test_search_by_keywords
    assert_equal ["Logica umana"], search(:keywords => "logica")
  end

  def test_all_keywords_are_required
    Document.create!(:title => "Logica inumana", :id_sbn => "boh")
    assert_equal ["Logica inumana", "Logica umana"], search(:keywords => "logica")
    assert_equal ["Logica umana"], search(:keywords => "logica umana")
  end
  
  def test_no_modifications_to_params
    original = { :keywords => "Logica", :century => "XVII" }
    copy = original.dup
    Document.find_all_by_options(copy)
    assert_equal original, copy
  end

private

  def search(options)
    documents = Document.find_all_by_options(options)
    documents.map(&:title) if documents
  end
end