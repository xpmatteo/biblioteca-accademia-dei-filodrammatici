require File.dirname(__FILE__) + '/../test_helper'
require 'graduates_controller'

class GraduatesControllerTest < Test::Unit::TestCase

  # cerchiamo di simulare l'ambiente in cui gira il GraduateHelper, con tutti i metodi
  # di ActionView definiti
  def mailto(email)
    'encrypted-email'
  end

  # carichiamo il modulo nel test case, così possiamo chiamare i suoi metodi
  include GraduatesHelper

  def test_graduate_attribute_is_nil_when_attribute_is_blank
    assert_nil graduate_attribute('foo', nil)
    assert_nil graduate_attribute('foo', '')
    assert_nil graduate_attribute('foo', '', :upcase) 
  end

  def test_graduate_attribute_without_post_processing
    assert_contains 'zot', graduate_attribute('foo', 'zot')
  end
  
  def test_graduate_attribute_post_processing
    assert_contains 'BAR', graduate_attribute('foo', 'bar', :upcase)
    assert_contains 'encrypted-email', graduate_attribute('foo', 'bar', :mailto)
    assert_contains 'ZOT', graduate_attribute('foo', 'zot') { |a| return a.upcase }
  end
end
