require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents, :authorships, :marc_fields, :marc_subfields
  
  def test_authors
    d = documents(:logica_umana)
    assert_equal 1, d.authors.count
    assert_equal 'Mor, Carlo A.', d.authors[0].name
  end
  
  def test_publication
    doc = documents(:logica_umana)
    assert_equal 'Rimini', doc.place_of_publication
    assert_equal '1906', doc.date_of_publication
    assert_equal 'Tp. Renzi', doc.publisher
    assert_equal 'Rimini: Tp. Renzi, 1906', doc.publication
  end
  
  def test_marc_fields
#    assert_equal ["200", "210"], documents(:il_vecchio_e_il_mare).marc_fields.map {|f| f.tag }
  end
  
  def test_title
#    
  end
end
