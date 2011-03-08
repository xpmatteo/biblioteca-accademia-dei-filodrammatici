require File.dirname(__FILE__) + '/../test_helper'

class ResponsibilitiesHelperTest < Test::Unit::TestCase
  self.use_transactional_fixtures = false  

  include DocumentsHelper
  
  def text_field *args
    "text_field(#{args.inspect})"
  end
  
  def text_area *args
    "text_area(#{args.inspect})"
  end
  
  def test_renders_text_field_in_html
    expected = %Q(<p><label for="document_field_name">label text</label><br/>\n) +
            (text_field 'document', 'field_name', :size => 50) + 
            "</p>\n"
    
    assert_equal expected, filo_text_field("label text", "field_name")
  end

  def test_renders_text_area_in_html
    expected = %Q(<p><label for="document_field_name">label text</label><br/>\n) +
            (text_area 'document', 'field_name', :size => "50x6") + 
            "</p>\n"
    
    assert_equal expected, filo_text_area("label text", "field_name")
  end

end
