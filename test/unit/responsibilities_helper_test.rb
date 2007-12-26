require File.dirname(__FILE__) + '/../test_helper'

class ResponsibilitiesHelperTest < Test::Unit::TestCase
  fixtures :documents, :authors, :responsibilities

  self.use_transactional_fixtures = false  

  include ResponsibilitiesHelper
  
  def test_can_be_deleted_unless_its_the_primary_author
    resp = responsibilities(:praz_curatore_di_teatro_elisabettiano)
    assert can_be_deleted(resp)

    document = documents(:teatro_elisabettiano)
    document.author = authors(:praz_mario)
    document.save!

    resp.reload
    assert_false can_be_deleted(resp), "non dovrebbe"
  end

end
