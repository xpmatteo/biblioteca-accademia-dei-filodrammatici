#--
# $Id: marc_xml_writer.rb,v 1.5 2005/12/11 15:33:22 bpeters Exp $
#
# Copyright (c) 2005 Bas Peters
#
# This file is part of RMARC
# 
# RMARC is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public 
# License as published by the Free Software Foundation; either 
# version 2.1 of the License, or (at your option) any later version.
# 
# RMARC is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public 
# License along with RMARC; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#++
require 'rexml/document'

module RMARC
  
  # Class for writing MARC record objects in MARC XML format.
  # 
  # The following example reads a file with MARC records 
  # and outputs the record set in MARC XML format: 
  # 
  #   writer = RMARC::MarcXmlWriter.new(STDOUT)
  #   reader = RMARC::MarcStreamReader.new("file.mrc")
  #   writer.start_document        
  #   while reader.has_next
  #       record = reader.next()
  #       writer.write_record(record)
  #   end
  #   writer.end_document
  #
  # See: http://www.loc.gov/standards/marcxml for more information about MARC XML.
  
  class MarcXmlWriter
    
    # Default constructor.
    def initialize(output)
      @output = output
    end
    
    # Writes the XML declaration and the collection start tag:
    #
    #   <?xml version='1.0' encoding='UTF-8'?>
    #   <collection xmlns="http://www.loc.gov/MARC21/slim">
    #
    # The default encoding is UTF-8.
    def start_document(encoding = nil)
      decl = REXML::XMLDecl.new
      if encoding
        decl.encoding = encoding
      else
        decl.encoding = "UTF-8"
      end
      @output.write(decl)
      @output.write("\n<collection xmlns=\"http://www.loc.gov/MARC21/slim\">")
    end
    
    # Writes a single record element:
    #
    #   <record>
    #     <leader>00714cam a2200205 a 4500</leader>
    #     <controlfield tag='001'>12883376</controlfield>
    #     ...
    #     <datafield tag='245' ind1='1' ind2='0'>
    #       <subfield code='a'>Summerland /</subfield>
    #       <subfield code='c'>Michael Chabon.</subfield>
    #     </datafield>
    #     ...
    #   </record>    
    def write_record(record)
      @output.write("\n  ")
      rec = REXML::Element.new('record')
      ldr = REXML::Element.new('leader')
      ldr.add_text(record.leader.to_s)
      rec.add_element(ldr)
      
      record.fields.each { |field| 
        if field.tag.to_i < 10
          fld = REXML::Element.new('controlfield')
          fld.add_attribute('tag', field.tag)
          fld.add_text(field.data)
          rec.add_element(fld)
        else
          fld = REXML::Element.new('datafield')
          fld.add_attribute('tag', field.tag)
          fld.add_attribute('ind1', field.ind1)
          fld.add_attribute('ind2', field.ind2)
          field.subfields.each { |subf| 
            sub = REXML::Element.new('subfield')
            sub.add_attribute('code', subf.code)
            sub.add_text(subf.data)
            fld.add_element(sub)
          }
          rec.add_element(fld)
        end
      }
      rec.write(@output, 1)
    end
    
    # Writes the collection end tag:
    #
    #   </collection> 
    def end_document
      @output.write("\n</collection>")
    end
    
  end
  
end