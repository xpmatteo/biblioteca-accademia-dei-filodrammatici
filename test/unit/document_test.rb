require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase

  def setup
    Document.delete_all
  end

  def test_import
    Document.import_unimarc File.dirname(__FILE__) + '/../fixtures/dump_books.xml'
    assert_equal 5, Document.count
    docs = Document.find(:all, :order => 'id')
    d0 = docs[0]
    d1 = docs[1]
    d2 = docs[2]
    d3 = docs[3]
    assert_equal 'IT\ICCU\AQ1\0031672', d0.sbn_record_id

    assert_equal 'ita', d0.language
    assert_equal 'eng', d1.language

    assert_equal 'Teatro elisabettiano', d0.title
    assert_equal 'Teatro elisabettiano', d0.title_without_article
    assert_equal 'Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford', d0.subtitles
    assert_equal 'Firenze', d0.place_of_publication
    assert_equal 'Sansoni', d0.publisher
    assert_equal 'stampa 1954', d0.date_of_publication
    assert_equal 'Marco Praga', d2.responsibility
    assert_equal 'a cura di Ruggero Rimini', d2.sub_responsibility

    # gestione "asterisco" 
    assert_equal "L' Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d3.title 
    assert_equal "Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d3.title_without_article
  end
  
  def test_regexp
    assert_equal 'foo', Document.after_asterisk('HblaIfoo')
    assert_equal 'blafoo', Document.remove_asterisk('HblaIfoo')
  end
end
