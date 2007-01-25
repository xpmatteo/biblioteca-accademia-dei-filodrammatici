module ImportTestHelper
  def assert_author(expected)
    assert_equal expected, @document.author.name, "autore diverso da atteso"
  end

  def assert_collection(expected)
    assert_equal expected, @document.collection, "collezione diversa da atteso"
  end
  
  def assert_names(expected)
    assert_equal expected, @document.names.map {|n| n.name} , "nomi diversi da atteso"
  end
  
  def assert_issued_with(expected)
    assert_equal expected.sort, @document.children.map {|n| n.title}.sort , "issued_with diversi da atteso"
  end
  
  def assert_place_publisher_year(place, publisher, year, message=nil)
    assert_equal place, @document.place, message
    assert_equal publisher, @document.publisher, message
    assert_equal year, @document.year, message
  end

  %w(title publication notes signature footprint physical_description signature footnote 
    year place publisher century hierarchy_type
    national_bibliography_number collection_volume collection_name responsibilities_denormalized).each do |attribute|
    self.class_eval <<-END
      def assert_#{attribute}(expected, message="")
        assert_equal expected, @document.attributes["#{attribute}"], "#{attribute} diverso da atteso " + message
      end
    END
  end

  def import(xml_string)
    @document = nil
    path = "/tmp/test_rails"
    File.open(path, "w") do |f|
      f.write(xml_string)
    end
    UnimarcImporter.new.import_xml path
    @document = Document.find(:first, :limit => 1, :order => "id desc")
    assert_not_nil @document, "non è riuscito a caricare nulla?!?"
  end
  
  def import_this_tag(xml_tag)
    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">IT\\ICCU\\BVE\\0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">Title</subfield>
        </datafield>    
        #{xml_tag}
      </record>
    </collection>
    SCHEDA
  end
end