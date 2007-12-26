require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents, :responsibilities, :publishers_emblems

  self.use_transactional_fixtures = false

  def test_find_by_keywords_in_title
    assert_found_by_keywords [:teatro_elisabettiano], "elisabettiano"
    assert_found_by_keywords [:logica_umana], "logica umana"
    assert_found_by_keywords [:logica_umana], "Rimini"
  end
    
  def test_find_by_keywords_in_author
    assert_found_by_keywords [:logica_umana], "carlo"
    assert_found_by_keywords [:logica_umana], "Carlo Mor"
  end
  
  def test_find_by_all_words
    Document.create!(:title => "Logica inumana", :id_sbn => "boh")
    assert_found_by_keywords [:logica_umana], "logica umana"
  end

  def test_prepare_keywords_for_boolean_mode_query
    assert_equal "+foo +bar", Document.prepare_keywords_for_boolean_mode_query("foo bar")
    assert_equal "+foo +bar", Document.prepare_keywords_for_boolean_mode_query("foo      bar")
  end
  
  # def test_relevance
  #   Document.create!(:title => "Logica, logica e ancora logica inumana", :id_sbn => "123")
  #   Document.create!(:title => "Logica, ma non troppo", :id_sbn => "456")
  #   found = Document.find_by_keywords("logica").map { |d| d.id_sbn }
  #   assert_equal ["123", "456", "IT\\ICCU\\ANA\\0077010"], found
  # end
  
private
  def assert_found_by_keywords(expected, keywords)
    actual = Document.find_by_keywords(keywords).map { |d| d.title }
    expected = expected.map { |sym| documents(sym).title }
    assert_equal expected, actual
  end

end