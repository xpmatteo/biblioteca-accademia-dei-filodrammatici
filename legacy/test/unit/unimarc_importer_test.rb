require File.dirname(__FILE__) + '/../test_helper'
require 'rmarc'

class MarcLibTest < Test::Unit::TestCase

  def setup
    @unimarc = Import::UnimarcImporter.new
  end

  def test_construct_title
    set_field(200, 'a' => 'Foo')
    assert_equal "Foo", @unimarc.construct_title

    set_field(200, 'a' => 'Foo', 'e' => 'Bar')
    assert_equal "Foo : Bar", @unimarc.construct_title

    set_field(200, 'a' => 'Foo', 'e' => 'Bar', 'f' => 'Baz')
    assert_equal "Foo : Bar / Baz", @unimarc.construct_title

    set_field(200, 'a' => 'Foo', 'f' => 'Baz')
    assert_equal "Foo / Baz", @unimarc.construct_title

    set_field(200, 'a' => 'Foo', 'g' => 'Punto')
    assert_equal "Foo ; Punto", @unimarc.construct_title

    set_field(200, 'a' => 'Foo', 'g' => 'Una G')
    add_subfield('g', 'Altra G')
    assert_equal "Foo ; Una G ; Altra G", @unimarc.construct_title
    
    set_field(200, 'a' => 'Foo', 'c' => 'Bla')
    assert_equal "Foo . Bla", @unimarc.construct_title
  end
  
  def test_construct_publisher
    set_field(210, 'a' => 'Foo')
    add_subfield('a', 'Bar')
    assert_equal "Foo; Bar", @unimarc.construct_publisher    

    set_field(210, 'a' => 'Foo', 'c' => 'Bar')
    assert_equal "Foo: Bar", @unimarc.construct_publisher    

    set_field(210, 'a' => 'Foo', 'e' => 'Bar')
    assert_equal "Foo (Bar)", @unimarc.construct_publisher
    
    set_field(210, 'a' => 'Milano', 'c' => '[s.n.]', 'd' => '1931', 'e' => 'Milano', 'g' => 'Off. Graf.', 'h' => '1931')
    assert_equal "Milano: [s.n.], 1931 (Milano: Off. Graf., 1931)", @unimarc.construct_publisher          

    set_field(210, 'd' => '1975')
    assert_equal "1975", @unimarc.construct_publisher    
  end
  
private

  def set_field(code, subfields)
    @unimarc.field = RMARC::DataField.new(code, " ", " ")
    subfields.each_key do |code|
      add_subfield(code, subfields[code])
    end
  end
  
  def add_subfield(code, data)
    @unimarc.field.add(RMARC::Subfield.new(code, data))
  end

end
