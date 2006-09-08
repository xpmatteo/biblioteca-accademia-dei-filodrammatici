require File.dirname(__FILE__) + '/../test_helper'

class AuthorTest < Test::Unit::TestCase
  fixtures :authors

  def test_validation
    assert       Author.new(:name => 'Foo', :id_sbn => 'bar').save
    assert_false Author.new(:name => 'Foo').save
    assert_false Author.new(:id_sbn => 'bar').save
    assert_false Author.new.save
  end
end
