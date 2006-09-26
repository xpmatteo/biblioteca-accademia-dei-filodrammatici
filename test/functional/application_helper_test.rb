require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase
  fixtures :contents, :menu_items
  attr :params
  
  def setup
    @params = {}
  end

  # carichiamo il modulo nel test case, così possiamo chiamare i suoi metodi
  include ApplicationHelper

  def test_menuitem_is_not_current_section_when_different_controller
    params[:controller] = 'foo'
    menuitem = MenuItem.new(:controller => 'bar')
    assert_false menuitem_is_current_section?(menuitem)
  end

  def test_menuitem_is_current_section_when_same_controller_and_not_content
    params[:controller] = 'foo'
    menuitem = MenuItem.new(:controller => 'foo')
    assert menuitem_is_current_section?(menuitem), "stesso controller, ma non content"
  end

  def test_menuitem_is_current
    params[:controller] = 'content'
    params[:name] = 'carlo-porta'
    assert       menuitem_is_current?(menu_items(:carlo_porta)), "carlo porta è current"
    assert_false menuitem_is_current?(menu_items(:giuseppe_verdi)), "verdi non è current"
  end

  def test_menuitem_is_current_section_when_current
    params[:controller] = 'content'
    params[:name] = 'profilo-storico'
    assert menuitem_is_current_section?(menu_items(:profilo_storico)), "content controller, is current"
    assert_false menuitem_is_current_section?(menu_items(:zork)), "content controller, not related"
  end
  
  def test_menuitem_is_current_section_when_current_is_subitem
    params[:controller] = 'content'
    params[:name] = 'carlo-porta'
    assert menuitem_is_current_section?(menu_items(:profilo_storico)), "content controller, in subitem"
  end

  def test_menuitem_is_current_section_when_current_is_subitem_which_is_not_content
    params[:controller] = 'graduates'
    assert menuitem_is_current_section?(menu_items(:profilo_storico)), "content controller, in graduates subitem"
  end
end
