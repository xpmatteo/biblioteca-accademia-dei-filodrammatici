require File.dirname(__FILE__) + '/../test_helper'

class DocumentPaginationTest < Test::Unit::TestCase
  

  # nota: prima di abilitare la paginazione nella find_by_... occorre:
  # - convertire _tutte_ le ricerche fatte da documents_controller all'uso di find_all_by_options
  # - eliminare la vecchia paginazione e inserire quella alla will_paginate
  self.use_transactional_fixtures = false

  def setup
    Document.delete_all
    100.times do |n| 
      Document.create(:title => sprintf("foo-%02d", n), :document_type => "monograph")
    end    
  end

  def test_search_pagination
    actual = Document.paginate(:document_type => "monograph", :page => "3")
    assert_equal 10, actual.size
    assert_equal %w(foo-20 foo-21 foo-22 foo-23 foo-24 foo-25 foo-26 foo-27 foo-28 foo-29), actual.map(&:title)
    assert_equal [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], actual.map(&:result_index)
  end
  
  def test_result_indexes
    actual = Document.paginate(:document_type => "monograph", :page => "1")
    assert_equal array(0, 10), actual.map(&:result_index)
    
    actual = Document.paginate(:document_type => "monograph", :page => "3")
    assert_equal array(20, 30), actual.map(&:result_index)    
    
    actual = Document.paginate(:document_type => "monograph", :per_page => 100000, :page => 1)
    assert_equal array(0, 100), actual.map(&:result_index)    
  end
  
  def test_total_entries
    actual = Document.paginate(:document_type => "monograph", :page => "3")
    assert_equal 100, actual.total_entries  
  end
  
  def test_default_pagination_params
    actual = Document.paginate(:document_type => "monograph")
    assert_equal array(0, 10), actual.map(&:result_index)
  end
  
  private
  
  def array(from, to)
    result = []
    for i in (from...to)
      result << i
    end
    result
  end

end
