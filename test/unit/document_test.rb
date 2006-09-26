require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :authors, :documents
  
  def test_author
    assert_equal 3, Author.count
#    puts Author.find(:all).map {|a| a.id}
    assert_equal authors(:hemingway), documents(:per_chi_suona_la_campana).author
  end
end
