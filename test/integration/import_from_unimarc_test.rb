require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase

  def setup
    Document.delete_all
    Author.delete_all
    MarcField.delete_all
    MarcSubfield.delete_all
    Document.import_unimarc File.dirname(__FILE__) + '/../fixtures/dump_books.xml'
  end
  
  def test_import_authors
    assert_equal 3, Author.count
    authors = Author.find(:all, :order => 'id')
    prospero = Author.find_by_name('Mandosio, Prospero <1650-1709>')
    assert_equal 1, prospero.documents.size
  end

  def test_import_marc_fields
    logica_umana = Document.find_by_id_sbn('IT\ICCU\ANA\0077010')
    assert_equal %w(100 101 102 200 210 215 700 801 899 899), logica_umana.marc_fields.map {|f| f.tag}
    assert_equal %w(a f), logica_umana.marc_fields.find_by_tag(200).subfields.map{|sf| sf.code}
    assert_equal 'Logica umana', 
      logica_umana.marc_fields.find_by_tag('200').subfields.find_by_code('a').body
  end

  def test_import_simple_book_acceptance
    d = Document.find_by_id_sbn('IT\ICCU\ANA\0077010')
    assert_equal 'Logica umana / dramma in cinque atti di Carlo A. Mor rappresentato per la prima volta a Genova',
      d.title
    assert_equal 'Rimini: Tp. Renzi, 1906', d.publication
    assert_equal 'Inglese', d.language
    assert_equal 'Monografia', d.bibliographic_level
    assert_equal '111 p. : ill. ; 17 cm', d.physical_description
    assert_equal 'Testo a stampa', d.document_type
  end
  
  

  def test_import_complex_book_acceptance
    d = Document.find_by_id_sbn('IT\ICCU\AQ1\0031672')
    assert_equal 'Italiano', d.language

    assert_equal 'Teatro elisabettiano / Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford', d0.title
    assert_equal d0.title, d0.title_without_article
    assert_equal 'Firenze', d0.place_of_publication
    assert_equal 'Sansoni', d0.publisher
    assert_equal 'stampa 1954', d0.date_of_publication

    assert_equal 'Praga, Marco', d2.author.name
    assert_nil d0.author

    assert_equal "L' Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d3.title 
    assert_equal "Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d3.title_without_article
  end  
  
end
