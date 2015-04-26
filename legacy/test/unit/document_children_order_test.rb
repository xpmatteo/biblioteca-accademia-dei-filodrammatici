require File.dirname(__FILE__) + '/../test_helper'

class DocumentChildrenOrderTest < Test::Unit::TestCase
  
  def setup
    Document.delete_all    
    @parent = Document.new(:title => "parent", :id_sbn => "parent")
    @parent.save!
  end
  
  def test_should_order_alphabetically
    assert_children_order %w(bar baz foo)
  end
  
  def test_should_order_numerically
    assert_children_order ["1 bla", "2 bla bla", "10 foo"]
  end

  def test_should_respect_asterisks
    assert_children_order ["Il *bla", "foo", "E lo *Zork"]
  end
  
private

  def add_children(children)
    for child in children
      @parent.children.build(:title => child, :id_sbn => child)
    end
    @parent.save!
  end
  
  def assert_children_order(expected)
    add_children(expected)
    assert_equal expected, @parent.reload.children.map{|child| child.title}
  end
end