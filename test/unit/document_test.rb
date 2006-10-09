require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents, :marc_fields
  
  def test_regexp
    assert_equal 'foo', Document.after_asterisk('HblaIfoo')
    assert_equal 'blafoo', Document.remove_asterisk('HblaIfoo')
  end
  
  def test_author
    assert_equal authors(:hemingway), documents(:per_chi_suona_la_campana).author
  end
  
  def test_publication
    assert_equal 'Milano: Mondadori, 1950', documents(:il_vecchio_e_il_mare).publication
  end
  
  def test_marc_fields
    assert_equal ["200", "210"], documents(:il_vecchio_e_il_mare).marc_fields.map {|f| f.tag }
  end
end
