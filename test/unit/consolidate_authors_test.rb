require File.dirname(__FILE__) + '/../test_helper'

class ConsolidateAuthorsTest < Test::Unit::TestCase
  def setup
    Author.delete_all
    Document.delete_all
    Responsibility.delete_all

    @author_with_dupes = Author.create!(:name => "Pippo", :id_sbn => "123")
    @dupe_author =       Author.create!(:name => "Pippo", :id_sbn => "456")
    @document_of_awd =   Document.create!(:title => "foo", :id_sbn => "foo", :author_id => @author_with_dupes.id)
    @document_of_dupe =  Document.create!(:title => "bar", :id_sbn => "bar", :author_id => @dupe_author.id)
  end

  # def test_should_delete_authors_without_documents
  #   assert_not_nil Author.find_by_id_sbn("456"), "non ha cancellato il duplicato"
  #   
  #   Author.consolidate!
  #   
  #   assert_nil Author.find_by_id_sbn("456"), "non ha cancellato il duplicato"
  # end
  
  def test_should_find_duplicate_authors
    assert_equal [@author_with_dupes], Author.authors_with_duplicates
  end

  def test_should_find_duplicates_of_authors
    assert_equal [@dupe_author], Author.duplicates_of(@author_with_dupes)
  end

  def test_should_move_responsibility_from_author_to_author
    assert_equal 1, Author.find(@author_with_dupes).documents.count    
    Author.transfer_responsibilities_from_to(@dupe_author, @author_with_dupes)
    assert_equal 2, Author.find(@author_with_dupes).documents.count    
  end

  def test_should_delete_dupe_after_transfer
    Author.consolidate!
    assert_nil Author.find_by_id(@dupe_author.id), "non lo ha cancellato"        
  end
  
  def test_should_mantain_primary_authorship
    assert_equal @dupe_author, @document_of_dupe.author
    Author.transfer_responsibilities_from_to(@dupe_author, @author_with_dupes)
    assert_equal @author_with_dupes, @document_of_dupe.reload.author
  end
end
