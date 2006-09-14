require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents
  
  def test_author
    assert_equal authors(:hemingway), documents(:per_chi_suona_la_campana).author
  end
end
