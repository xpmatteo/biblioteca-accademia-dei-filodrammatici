require File.dirname(__FILE__) + '/../test_helper'

class ResponsibilitiesHelperTest < Test::Unit::TestCase
  self.use_transactional_fixtures = false  

  include DocumentsHelper
  
  def text_field *args
    args.inspect
  end
  
  def test_renders_text_field_in_html
    expected = %Q(<p><label for="document_field_name">label text</label><br/>\n) +
            (text_field 'document', 'field_name', :size => 50) + 
            "</p>\n"
    
    assert_equal expected, filo_text_field("label text", "field_name")
  end

end
