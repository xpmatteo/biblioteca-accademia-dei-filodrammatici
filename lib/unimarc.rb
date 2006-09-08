require 'rmarc'

class RMARC::DataField
  def get_subfield(code)
    subfield = find {|s| s.code == code}
    subfield.data if subfield
  end
end

module Unimarc
  def import(filename)
    reader = RMARC::MarcXmlReader.new(filename)
    while reader.has_next
      record = reader.next()
      d = Document.new
      record.each do |field|
        case field.tag
        when '001' 
          d.sbn_record_id = field.data
        when '101'
          d.language = field.get_subfield('a')
        when '200'
          d.title = remove_asterisk(field.get_subfield('a'))
          d.title_without_article = after_asterisk(field.get_subfield('a'))
          d.subtitles = field.get_subfield('e')
          d.responsibility = field.get_subfield('f')
          d.sub_responsibility = field.get_subfield('g')
        when '210'
          d.place_of_publication = field.get_subfield('a')
          d.publisher = field.get_subfield('c')
          d.date_of_publication = field.get_subfield('d')
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
end