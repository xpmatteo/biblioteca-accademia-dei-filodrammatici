require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents, :responsibilities, :publishers_emblems
  
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
  
  def test_no_collection
    d = Document.new(:title => "foobar")
    assert_nil d.collection, "collezione non nulla?"
  end
  
  def test_collection_without_volume
    d = documents(:teatro_elisabettiano)
    d.collection_name = "Pippo"
    assert_equal "Pippo", d.collection
  end

  def test_collection_with_volume
    d = documents(:teatro_elisabettiano)
    d.collection_name = "Pippo"
    d.collection_volume = "12"
    assert_equal "Pippo; 12", d.collection
  end
  
  def test_collection_treats_empty_strings_just_like_nils
    d = documents(:teatro_elisabettiano)

    d.collection_name = ""
    assert d.collection.blank?, "non blank after name"   

    d.collection_volume = ""
    assert d.collection.blank?, "after volume"

    d.collection_name = "foo"
    assert_equal "foo", d.collection_name, "only volume is empty"
  end

  def test_find_by_keywords_in_title
    assert_found_by_keywords [:teatro_elisabettiano], "elisabettiano"
    assert_found_by_keywords [:logica_umana], "logica umana"
    assert_found_by_keywords [:logica_umana], "Rimini"
  end
  
  def test_find_by_keywords_in_author
    assert_found_by_keywords [:logica_umana], "carlo"
    assert_found_by_keywords [:logica_umana], "Carlo Mor"
  end
  
  def test_issued_with
    root = documents(:teatro_elisabettiano)
    assert_nil root.parent, "non ha genitore"
    assert_equal [], root.children, "non ha figli"
    root.children << documents(:logica_umana)
    assert_equal ["Logica umana"], root.children.map {|child| child.title }, "ha un figlio"
    assert_equal Document.find_by_title("Logica umana").parent, root
  end

  def test_should_not_include_children_when_parent_is_present
    save author = Author.new(:name => 'Pippo', :id_sbn => "xyz")
    parent = Document.new(:title => "parent", :author => author, :id_sbn => "foo")
    child = Document.new(:title => "child", :author => author, :id_sbn => "bar")
    parent.children << child
    save parent
    assert_equal [parent], Document.prune_children([parent, child])
  end
  
  def test_should_use_monograph_as_default_type
    d = Document.new(:title => "foo", :id_sbn => "5431")
    save d
    assert_equal "monograph", d.document_type
  end
  
  def test_should_validate_type
    d = Document.new(:title => "foo", :id_sbn => "12345")
    assert_valid d
    d.document_type = "x", "x should not be valid"
    assert_invalid d
    d.document_type = "serial"
    assert_valid d
  end
  
  def test_should_validate_hierarchy_type
    d = Document.new(:title => "foo", :id_sbn => "12345---")
    assert_valid d
    d.hierarchy_type = "x"
    assert_invalid d, "x is not a valid type"
    d.hierarchy_type = "issued_with"
    assert_valid d
    d.hierarchy_type = "composition"
    assert_valid d
    d.hierarchy_type = "serial"
    assert_valid d
  end
  
  def test_should_add_author_to_names
    a = authors(:mor_carlo)
    d = Document.new(:title => "foo", :id_sbn => "xyz123", :author_id => a.id)
    save d
    d = Document.find_by_id_sbn("xyz123")
    assert d.names.member?(a), " non lo ha aggiunto"
  end
  
  def test_should_not_add_names_twice
    a = authors(:mor_carlo)
    d = Document.new(:title => "foo", :id_sbn => "xyz321", :author_id => a.id)
    save d
    assert_raise (ActiveRecord::StatementInvalid) { d.names << a }
  end
  
  def test_should_not_show_asterisks_in_title
    d = Document.new(:title => "The *Foo", :id_sbn => "bla")
    assert_equal "The Foo", d.title_without_asterisk
  end
  
  def test_publishers_emblem
    assert_equal "Un leone rampante", documents(:anno_1802).publishers_emblem.description
  end
  
private
  def assert_found_by_keywords(expected, keywords)
    actual = Document.find_by_keywords(keywords).map { |d| d.title }
    expected = expected.map { |sym| documents(sym).title }
    assert_equal expected, actual
  end
end
