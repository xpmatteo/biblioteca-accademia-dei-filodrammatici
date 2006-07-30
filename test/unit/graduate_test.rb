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
    assert g.save, "non ha salvato: " + g.errors.full_messages.join("\n")
    assert_equal ['D', 'G'], Graduate.initials
  end                                         

  def test_validate_email
    assert_this_email_is_valid '' # allow missing email
    assert_this_email_is_valid 'foo@bar.com'
    assert_this_email_is_not_valid 'foo@bar.com@'
  end
  
private

  def assert_this_email_is_valid(email)
    g = graduates(:geppo) 
    g.email = email
    assert g.save, "address '#{email}' should be valid"
  end

  def assert_this_email_is_not_valid(email)
    g = graduates(:geppo) 
    g.email = email
    assert !g.save, "address '#{email}' should be invalid"
  end
end
