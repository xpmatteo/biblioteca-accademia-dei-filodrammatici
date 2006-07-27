require File.dirname(__FILE__) + '/../test_helper'

class GraduateTest < Test::Unit::TestCase
  fixtures :graduates

  def test_graduation_years
    assert_equal [2003, 2005], Graduate.graduation_years
  end                  
  
  def test_initials
    assert_equal ['D', 'G'], Graduate.initials
  end
  
  def test_initials_ignores_case                  
    g = graduates(:pippo)
    g.last_name = 'de Pippis'
    g.save
    assert_equal ['D', 'G'], Graduate.initials
  end                                         
  
end
