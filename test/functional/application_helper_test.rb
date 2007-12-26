require File.dirname(__FILE__) + '/../test_helper'

class ApplicationHelperTest < Test::Unit::TestCase
  fixtures :contents
  attr :params
  
  def setup
    @params = {}
  end

  # carichiamo il modulo nel test case, così possiamo chiamare i suoi metodi
  include ApplicationHelper

  def test_truth
  end

end
