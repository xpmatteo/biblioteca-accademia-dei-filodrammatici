require File.dirname(__FILE__) + '/../test_helper'

class TeacherTest < Test::Unit::TestCase
  fixtures :teachers

  def test_name
    teacher = teachers(:clough)
    assert_equal 'Peter CLOUGH', teacher.name
  end
end
