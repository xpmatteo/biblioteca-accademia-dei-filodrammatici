require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase

  def setup
    Document.delete_all
    Document.import_unimarc File.dirname(__FILE__) + '/../fixtures/dump_books.xml'
  end

  def test_import
    assert_equal 5, Document.count
    docs = Document.find(:all, :order => 'id')
    d0 = docs[0]
    d1 = docs[1]
    assert_equal 'IT\ICCU\AQ1\0031672', d0.sbn_record_id

    assert_equal 'ita', d0.language
    assert_equal 'eng', d1.language

    assert_equal 'Teatro elisabettiano', d0.title
  end
end
