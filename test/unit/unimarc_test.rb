require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents
  
  # def setup
  #   Document.delete_all
  #   Author.delete_all
  #   Document.import_unimarc File.dirname(__FILE__) + '/../fixtures/dump_books.xml'
  # end
  # 
  # def test_import_documents
  #   assert_equal 5, Document.count
  #   docs = Document.find(:all, :order => 'id')
  #   d0 = docs[0]
  #   d1 = docs[1]
  #   d2 = docs[2]
  #   d3 = docs[3]
  # 
  #   assert_equal 'IT\ICCU\AQ1\0031672', d0.id_sbn
  # 
  #   assert_equal 'ita', d0.language
  #   assert_equal 'eng', d1.language
  # 
  #   assert_equal 'Teatro elisabettiano', d0.title
  #   assert_equal 'Teatro elisabettiano', d0.title_without_article
  #   assert_equal 'Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford', d0.subtitles
  #   assert_equal 'Firenze', d0.place_of_publication
  #   assert_equal 'Sansoni', d0.publisher
  #   assert_equal 'stampa 1954', d0.date_of_publication
  # 
  #   assert_equal 'Praga, Marco', d2.author.name
  #   assert_nil d0.author
  # 
  #   # gestione "asterisco" 
  #   assert_equal "L' Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d3.title 
  #   assert_equal "Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d3.title_without_article
  # end
  # 
  # def test_import_authors
  #   assert_equal 3, Author.count
  #   authors = Author.find(:all, :order => 'id')
  #   prospero = Author.find_by_name('Mandosio, Prospero <1650-1709>')
  #   assert_equal 2, prospero.documents.size
  # end
  # 
  # def test_regexp
  #   assert_equal 'foo', Document.after_asterisk('HblaIfoo')
  #   assert_equal 'blafoo', Document.remove_asterisk('HblaIfoo')
  # end
end
