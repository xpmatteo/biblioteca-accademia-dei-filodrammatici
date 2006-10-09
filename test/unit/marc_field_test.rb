require File.dirname(__FILE__) + '/../test_helper'

class MarcFieldTest < Test::Unit::TestCase
  fixtures :marc_fields, :marc_subfields

  def test_subfields
    assert_equal ["a", "e"], MarcField.find(100).subfields.map {|sf| sf.code }
  end
end
