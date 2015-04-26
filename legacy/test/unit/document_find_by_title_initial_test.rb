require File.dirname(__FILE__) + '/../test_helper'

class DocumentFindByTitleInitialTest < Test::Unit::TestCase  
  self.use_transactional_fixtures = false
  
  def setup
    Document.delete_all
    Document.create!(:title => "L'*Abbazia")
    Document.create!(:title => "Acqua")
    Document.create!(:title => "Zzzz")
    Document.create!(:title => "Lo* spazio")
  end

  def test_search_by_title_initial_z
    assert_equal %w(Zzzz), search(:title_initial => 'Z')
  end

  def test_with_asterisk
    assert_equal ["L'*Abbazia", "Acqua"], search(:title_initial => 'A')
  end

  def test_with_space_after_asterisk
    assert_equal ["Lo* spazio"], search(:title_initial => 'S')
  end

private

  def search(options)
    documents = Document.paginate(options.merge(:page => "1"))
    documents.map(&:title) if documents
  end
end
