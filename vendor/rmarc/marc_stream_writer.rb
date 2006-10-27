#--
# $Id: marc_stream_writer.rb,v 1.5 2005/12/11 15:33:22 bpeters Exp $
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
# ++
module RMARC
  
  # Class for writing MARC record objects in ISO 2709 format.
  # 
  # The following example reads a file with MARC XML records 
  # and outputs the record set in ISO 2709 format: 
  #
  #   writer = RMARC::MarcStreamWriter.new(STDOUT)
  #   reader = RMARC::MarcXmlReader.new("file.xml")
  #   while reader.has_next
  #       record = reader.next()
  #       writer.write_record(record)
  #   end

  class MarcStreamWriter
    
    # Default constructor.
    def initialize(output)
      @output = output
    end
    
    # Writes a single record to the given output stream.
    def write_record(record)
      data = ""
      dir = ""
      prev = 0
      
      record.fields.each { 
        |field| 
        if field.tag.to_i < 10
          data << field.data << Constants.FT
        else
          data << field.ind1 << field.ind2
          field.subfields.each { |subf| data << Constants.US << subf.code << subf.data }
          data << Constants.FT
        end
        len = data.length
        dir << field.tag << "%04d" % (len - prev) << "%05d" % prev
        prev = len
      }
      dir << Constants.FT
      
      leader = record.leader
      leader.base_address = 24 + dir.length
      leader.record_length = leader.base_address + data.length + 1
      
      @output.write(leader.to_s << dir << data << Constants.RT)
    end  
  end
  
end