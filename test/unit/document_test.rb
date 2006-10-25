require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents, :marc_fields
  
  def test_names
    d = documents(:logica_umana)
    assert_equal 1, d.names.size
    assert_equal 'Mor, Carlo A.', d.names[0].name
    assert_equal 'IT\ICCU\ANAV\039809', d.names[0].id_sbn
  end
  
  def test_author
    d = documents(:logica_umana)
    assert_equal 'Mor, Carlo A.', d.author.name
    assert_equal 'IT\ICCU\ANAV\039809', d.author.id_sbn
  end
  
  def test_author_is_nil
    d = documents(:teatro_elisabettiano)
    assert_nil d.author, "teatro elisabettiano non ha un vero e proprio autore"
    assert_equal ['Baldini, Gabriele', 'Praz, Mario'], d.names.map { |a| a.name }
  end
  
  def test_publication
    doc = documents(:logica_umana)
    assert_equal 'Rimini', doc.place_of_publication
    assert_equal '1906', doc.date_of_publication
    assert_equal 'Tp. Renzi', doc.publisher
    assert_equal 'Rimini: Tp. Renzi, 1906', doc.publication
  end
  
end
