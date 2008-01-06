require File.dirname(__FILE__) + '/../test_helper'

class RomanNumeralsTest < Test::Unit::TestCase
  
  def test_decimal_to_roman
    assert_equal "foo", RomanNumerals.decimal_to_roman("foo")
    assert_equal "XV", RomanNumerals.decimal_to_roman(15)
  end
  
  def test_roman_to_decimal
    assert_equal 15, RomanNumerals.roman_to_decimal("XV")
    assert_equal nil, RomanNumerals.roman_to_decimal("")
  end
end