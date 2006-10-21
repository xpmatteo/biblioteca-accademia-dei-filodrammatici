require 'rmarc'
require 'unimarc_language_codes'

class RMARC::DataField
  def get_subfield(code)
    subfield = find {|s| s.code == code}
    subfield.data if subfield
  end
end

module Unimarc
  def do_import(filename)
    reader = RMARC::MarcXmlReader.new(filename)
    while reader.has_next
      record = reader.next()
      d = Document.new
      record.each do |field|
        import_marc_fields(d, field)
        
        case field.tag
        when '001' 
          d.id_sbn = field.data
        when '200'
          d.title_without_article = after_asterisk field.get_subfield('a')
        when '700'          
          id_sbn = field.get_subfield('3')
          author = 
            Author.find_by_id_sbn(id_sbn) || 
            Author.new(:name => field.get_subfield('a'), :id_sbn => id_sbn)
          author.save
        end
      end
      d.save
      print "."
      $stdout.flush
    end
  end
  
  def remove_asterisk(s)
    return $1 + $2 if s =~ /^H(.[^I]*)I(.*)$/
    s
  end

  def after_asterisk(s)
    return $1 if s =~ /^H.[^I]*I(.*)$/
    s
  end
  
  def import_marc_fields(document, field)
    return if field.tag.to_i < 100 
    marc_attributes = { :tag => field.tag }
    field.each do |subfield|
      marc_attributes["subfield_#{subfield.code}".to_s] = subfield.data
    end
    f = document.marc_fields.build(marc_attributes)
  end
  
  def expand_marc_country_code(code)
    return LANGUAGE_CODES[code] || code
  end
end
