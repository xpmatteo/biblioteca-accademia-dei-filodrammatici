require File.dirname(__FILE__) + '/../test_helper'

class ImportBaseTest < Test::Unit::TestCase
  
  def setup
    @importer = Import::Base.new
  end
  
  def test_should_remove_slash_and_author_name_from_title
    assert_equal "Foo", @importer.clean_title("Foo / di Bar")
    assert_equal "Bar", @importer.clean_title("Bar / de Foo")
    assert_equal "Zork", @importer.clean_title("Zork / Foo Bar")
  end
  
  def test_should_keep_info_after_author
    assert_equal "Yepeto; traduzione di Nestor Garay",
      @importer.clean_title("Yepeto / di Roberto Cossa ; traduzione di Nestor Garay")

    assert_equal "Foo. Sei testi di autori contemporanei.",
        @importer.clean_title("Foo / di Bla Bla. ((Sei testi di autori contemporanei.")
  end

  def test_should_not_touch_title_otherwise
    assert_equal "Zork bla", @importer.clean_title("Zork bla")    
  end

  def test_should_remove_asterisk_from_title
    assert_equal "Lo Zork", @importer.clean_title("Lo *Zork")    
  end
end

