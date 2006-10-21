require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents, :marc_fields
  
  def test_authors
    d = documents(:logica_umana)
    assert_equal 1, d.authors.size
    assert_equal 'Mor, Carlo A.', d.authors[0].name
    assert_equal 'IT\ICCU\ANAV\039809', d.authors[0].id_sbn
  end
  
  def test_publication
    doc = documents(:logica_umana)
    assert_equal 'Rimini', doc.place_of_publication
    assert_equal '1906', doc.date_of_publication
    assert_equal 'Tp. Renzi', doc.publisher
    assert_equal 'Rimini: Tp. Renzi, 1906', doc.publication
  end
  
end
