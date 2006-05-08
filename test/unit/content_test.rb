require File.dirname(__FILE__) + '/../test_helper'

class ContentTest < Test::Unit::TestCase
  fixtures :contents

  # Replace this with your real tests.
  def test_image_url
    c = Content.find(1)
    assert_equal "/images/foo.gif", c.full_image_url
  end
  
  def test_find_by_name
    assert_equal Content.find_by_name('welcome'), Content.find(1)
    assert_equal Content.find_by_name('foobar'), Content.find(2)
  end
  
  def test_validates_uniqueness_of_names
    c = contents('welcome').clone
    assert_false c.save, "non doveva salvarlo, nome duplicato"
    c.name = 'this.is.unique'
    assert c.save, "doveva salvarlo, nome unico"
  end
  
  def test_validates_presence_of_stuff
    c = contents('welcome').clone
    c.name = 'unique.name'
    assert c.save, c.errors.full_messages.join("\n")
    c.name = nil
    assert_false c.save, "non doveva salvarlo, manca il nome"
  end
end
