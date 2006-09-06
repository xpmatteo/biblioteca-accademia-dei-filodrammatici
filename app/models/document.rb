require 'rmarc'

class RMARC::DataField
  def get_subfield(code)
    subfield = find {|s| s.code == code}
    subfield.data if subfield
  end
end

class Document < ActiveRecord::Base

  def self.import_unimarc(filename)
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
          d.title = field.get_subfield('a')
        end
      end
      d.save
    end
  end

end
