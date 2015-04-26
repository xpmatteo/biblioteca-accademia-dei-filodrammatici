require File.dirname(__FILE__) + '/../test_helper'

class DocumentsHelperTest < Test::Unit::TestCase
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
    
    assert_equal expected, document_text_field("label text", "field_name")
  end

  def test_renders_text_area_in_html
    expected = %Q(<p><label for="document_field_name">label text</label><br/>\n) +
            (text_area 'document', 'field_name', :size => "50x6") + 
            "</p>\n"
    
    assert_equal expected, document_text_area("label text", "field_name")
  end

  def test_manuscripts_are_not_rendered_by_document_field
    @document = Document.new(:document_type => 'thesis')
    assert_equal "", document_text_field("label text", "field_name")
  end
  
  def test_manuscripts_are_not_rendered_by_document_area
    @document = Document.new(:document_type => 'manuscript')
    assert_equal "", document_text_area("label text", "field_name")
  end
  
  def test_all_documents_are_rendered_by_manuscript_text_field
    expected = document_text_field("any", "any")
    
    assert_equal expected, manuscript_text_field("any", "any")
    
    @document = Document.new(:document_type => 'manuscript')
    assert_equal expected, manuscript_text_field("any", "any")
  end
  
  def test_all_documents_are_rendered_by_manuscript_text_area
    expected = document_text_area("any", "any")
    
    assert_equal expected, manuscript_text_area("any", "any")
    
    @document = Document.new(:document_type => 'manuscript')
    assert_equal expected, manuscript_text_area("any", "any")
  end
  
end
