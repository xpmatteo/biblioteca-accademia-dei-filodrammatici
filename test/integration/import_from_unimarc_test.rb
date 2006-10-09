require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase

  # todo:
  # eliminare i campi derivati da Document
  # author deve diventare ??? cosa ???
  # relazione multiforme fra documenti e persone: autore, editore, o anche non specificata
  # la relazione pure va calcolata al volo ?
  

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
    assert_equal 'Mor, Carlo A.', d.authors
    assert_equal ['Mor, Carlo A.'], d.names.map {|n| n.name}
  end
  
  def test_import_complex_book_acceptance
    d = Document.find_by_id_sbn('IT\ICCU\AQ1\0031672')
    assert_equal 'Italiano', d.language
    assert_equal 'Monografia', d.bibliographic_level
    assert_equal 'Testo a stampa', d.document_type
    assert_equal 'Teatro elisabettiano / Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford', d.title
    assert_equal d.title, d.title_without_article
    assert_equal 'Firenze : Sansoni, stampa 1954', d.publication
    assert_equal 'XXVIII, 1274 p. ; 21 cm', d.physical_description

    # Collezione : 	I grandi classici stranieri
    assert_equal 'Trad. di Gabriele Baldini ... [et al.!, sotto la direzione di Mario Praz',
      d.general_notes
    
    assert_equal ['Praz, Mario', 'Baldini, Gabriele'], d.names.map {|n| n.name}
    assert_equal 'Italia', d.publication_country
    	
    assert_equal 'Firenze', d.place_of_publication
    assert_equal 'Sansoni', d.publisher
    assert_equal 'stampa 1954', d.date_of_publication
  end  

  def test_import_title_with_asterisk_acceptance
    d = Document.find_by_id_sbn('IT\ICCU\BVEE\023209')
    assert_equal 'Monografia', d.bibliographic_level
    assert_equal 'Testo a stampa', d.document_type
    assert_equal "L' Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d.title 
    assert_equal "Adargonte tragedia del signor Prospero Mandosi nobile romano, e caualiere di S. Stefano", d.title_without_article
    assert_equal 'Mandosio, Prospero <1650-1709>', d.authors
    assert_equal 'In Bologna : per Giuseppe Longhi, 1687', d.publication
    assert_equal '120 p. ; 12o.', d.physical_description
    assert_equal 'Segn.: A-E12.', d.general_notes
    assert_equal 'Segn.: A-E12.', d.general_notes
    assert_equal '- roi- o.e. .)di (Gpo (3) 1687 (R)', d.fingerprint

    # ???
    # Nomi: 	Mandosio, Prospero <1650-1709>
    # [Editore] Longhi, Giuseppe <1.> 	

    assert_equal 'Italia', d.publication_country
  end
end
