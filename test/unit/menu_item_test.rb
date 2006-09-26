require File.dirname(__FILE__) + '/../test_helper'

class MenuItemTest < Test::Unit::TestCase
  fixtures :menu_items, :contents

  def test_children
    assert_equal [], menu_items(:first).children
    assert_equal [menu_items(:giuseppe_verdi), menu_items(:carlo_porta), menu_items(:graduates)], 
                  menu_items(:profilo_storico).children
  end
  
  def test_parent
    assert_equal menu_items(:profilo_storico), menu_items(:giuseppe_verdi).parent
  end
  
  def test_root
    assert_equal [3, 2, 6], MenuItem.root.children.map{ |item| item.id }
  end
end
