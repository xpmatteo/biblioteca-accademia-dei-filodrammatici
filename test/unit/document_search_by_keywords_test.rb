require File.dirname(__FILE__) + '/../test_helper'

class DocumentSearchByKeywordsTest < Test::Unit::TestCase
  fixtures :authors, :documents, :responsibilities, :publishers_emblems

  self.use_transactional_fixtures = false

  def test_find_by_keywords_in_title
    assert_found_by_keywords ["Teatro Elisabettiano"], "elisabettiano"
    assert_found_by_keywords ["Logica umana"], "logica umana"
    assert_found_by_keywords ["Logica umana"], "Rimini"
  end
    
  def test_find_by_keywords_in_author
    assert_found_by_keywords ["Logica umana"], "carlo"
    assert_found_by_keywords ["Logica umana"], "Carlo Mor"
  end

  def test_find_by_all_words
    Document.create!(:title => "Logica inumana", :id_sbn => "boh")
    assert_found_by_keywords ["Logica inumana", "Logica umana"], "logica"
    assert_found_by_keywords ["Logica umana"], "logica umana"
  end

  def test_find_nothing
    assert_found_by_keywords [], "bla bla bla"
  end

  def test_prepare_keywords_for_boolean_mode_query
    assert_equal "+foo +bar", Document.prepare_keywords_for_boolean_mode_query("foo bar")
    assert_equal "+foo +bar", Document.prepare_keywords_for_boolean_mode_query("foo      bar")
  end
  
private
  def assert_found_by_keywords(expected, keywords)
    actual = Document.paginate(:keywords => keywords, :page => "1").map { |d| d.title }
    assert_equal expected, actual
  end

end