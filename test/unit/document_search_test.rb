require File.dirname(__FILE__) + '/../test_helper'

class DocumentSearchTest < Test::Unit::TestCase
  fixtures :authors, :documents, :responsibilities, :publishers_emblems
  
  self.use_transactional_fixtures = false

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
  
  def test_search_by_century_infers_century_from_year
    Document.delete_all
    Document.create!(:title => "son nel ventesimo", :year => "1999")
    assert_equal ["son nel ventesimo"], search(:century => "XX")
  end
  
  def test_search_by_keywords
    assert_equal ["Logica umana"], search(:keywords => "logica")
  end

  def test_no_modifications_to_params
    original = { :keywords => "Logica", :century => "XVII", :page => "111" }
    copy = original.dup
    Document.paginate(copy)
    assert_equal original, copy
  end

  def test_search_by_document_type
    Document.delete_all
    Document.create!(:title => "foo", :document_type => "monograph")
    Document.create!(:title => "bar", :document_type => "serial")
    Document.create!(:title => "baz", :document_type => "in-serial")
    
    assert_equal ["foo"], search(:document_type => 'monograph')
    assert_equal ["bar"], search(:document_type => 'serial')
    assert_equal ["baz"], search(:document_type => 'in-serial')
  end
  
  def test_search_prunes_children
    Document.delete_all
    parent = Document.create!(:title => "foo", :document_type => "monograph")
    child = parent.children.create!(:title => "bar", :document_type => "monograph")
    assert_equal ["foo"], search(:document_type => "monograph")
  end
  
  def test_search_by_author
    assert_equal ["Logica umana"], search(:author_id => authors(:mor_carlo))
    assert_nil documents(:teatro_elisabettiano).author
    assert_equal ["Teatro Elisabettiano"], search(:author_id => authors(:baldini_gabriele))

    Responsibility.delete_all
    assert_equal ["Logica umana"], search(:author_id => authors(:mor_carlo))
  end
  
  def test_by_emblem
    assert_equal [], search(:publishers_emblem_id => 0)
    assert_equal ["Nell'anno 1802"], search(:publishers_emblem_id => 1)
  end
  
  def test_by_year
    assert_equal [], search(:year => 2111)
    assert_equal ["Nell'anno 1802"], search(:year => 1802)
    assert_equal ["Nell'anno 1936"], search(:year => 1936)
  end
  
  def test_by_collection_name
    assert_equal [], search(:collection_name => "zot")
    assert_equal ["Pippo Topolino"], search(:collection_name => "Foo")
  end
  
private

  def search(options)
    documents = Document.paginate(options.merge(:page => "1"))
    documents.map(&:title) if documents
  end
end
