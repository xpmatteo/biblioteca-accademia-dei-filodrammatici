require File.dirname(__FILE__) + '/../test_helper'

class MarcLibTest < Test::Unit::TestCase
  include Unimarc
  
  def test_expand_marc_country_code
    assert_equal "italiano", expand_marc_country_code("ita")
    assert_equal "inglese", expand_marc_country_code("eng")
    assert_equal "xyz", expand_marc_country_code("xyz")
  end  
  
  def test_regexp
    assert_equal 'foo', after_asterisk('HblaIfoo')
    assert_equal 'blafoo', remove_asterisk('HblaIfoo')
  end
  
end
