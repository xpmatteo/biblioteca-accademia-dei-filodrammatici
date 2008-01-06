require File.dirname(__FILE__) + '/../test_helper'

class DocumentSearchByKeywordsTest < Test::Unit::TestCase
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
    
private
  def assert_found_by_keywords(expected, keywords)
    actual = Document.find_all_by_options(:keywords => keywords).map { |d| d.title }
    expected = expected.map { |sym| documents(sym).title }
    assert_equal expected, actual
  end

end