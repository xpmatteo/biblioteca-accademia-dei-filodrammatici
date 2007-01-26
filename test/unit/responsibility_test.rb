require File.dirname(__FILE__) + '/../test_helper'

class ResponsibilityTest < Test::Unit::TestCase

  def setup
    Responsibility.delete_all
  end

  def test_uniqueness
    save Responsibility.new(:author_id => 100, :document_id => 200)
    
    assert_raise (ActiveRecord::StatementInvalid) do
      Responsibility.new(:author_id => 100, :document_id => 200).save 
    end
  end
  
  def test_should_be_able_to_save_non_unique_records
    save Responsibility.new(:author_id => 100, :document_id => 200)
    save Responsibility.new(:author_id => 100, :document_id => 300)
    save Responsibility.new(:author_id => 500, :document_id => 200)    
  end
end
