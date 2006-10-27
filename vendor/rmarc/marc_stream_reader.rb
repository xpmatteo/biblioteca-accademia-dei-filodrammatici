#--
# $Id: marc_stream_reader.rb,v 1.5 2005/12/11 15:33:22 bpeters Exp $
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
module RMARC
  
  # This class provides an iterator over a collection of MARC records in ISO 2709 format.
  #
  # Example usage:
  #
  #   reader = RMARC::MarcStreamReader.new("file.mrc")
  #   while reader.has_next
  #       record = reader.next()
  #   end
  # 
  # You can also pass a file object:
  # 
  #   input = File.new("file.mrc")
  #   reader = RMARC::MarcStreamReader.new(input)
  #   while reader.has_next
  #       record = reader.next()
  #   end
  #   input.close
  #
  # Or any other IO subclass. 

  class MarcStreamReader
    
    private
    
    def parse_data_field(entry)
      msg = "Unexpected EOF while reading field with tag #{entry.tag}" 
      
      ind1 = @input.read(1)
      
      raise msg if ind1 == nil
      
      ind2 = @input.read(1)
      
      raise msg if ind2 == nil
      
      field = DataField.new(entry.tag, ind1, ind2)
      
      data = nil
      code = nil
      i = 2
      
      while i < entry.length
        s = @input.read(1)
        if s == nil
          raise msg
        elsif s == Constants.US        
          field.add(Subfield.new(code, data)) if code != nil
          code = @input.read(1)
          i += 1
          data = ""
        elsif s == Constants.FT
          field.add(Subfield.new(code, data)) if code != nil
        else
          data << s if data != nil
        end
        i += 1
      end
      return field  
    end
    
    public
    
    # Returns the next record in the iteration.
    def next
      ldr = @input.read(24)
      
      raise "Unexpected EOF while reading record label" if ldr == nil
      
      leader = Leader.new(ldr)
      
      record = Record.new(leader)
      
      length = leader.base_address - 25
      
      raise "Invalid directory" if length % 12 != 0
      
      dir = @input.read(length)
      
      entries = length / 12
      
      raise "Expected field terminator" if @input.read(1) != Constants.FT
      
      start = 0
      
      entries.times do
        entry = Directory.new(dir[start, 3], dir[start += 3, 4], dir[start += 4, 5])
        if (entry.tag.to_i < 10)
          data = @input.read(entry.length)
          
          raise "Unexpected EOF while reading field with tag #{entry.tag}" if data == nil
          
          record.add(ControlField.new(entry.tag, data.chop))
        else
          record.add(parse_data_field(entry))
        end
        start += 5
      end
      
      raise "Expected record terminator" if @input.read(1) != Constants.RT
      
      return record
    end
    
    # Returns true if the iteration has more records, false otherwise.
    def has_next
      if @input.eof == false
        return true
      else 
        return false
      end
    end
    
    # Default constructor    
    def initialize(input)
      if input.class == String
        @input = File.new(input)
      elsif input.class == File
        @input = input
      else
        throw "Unable to read from path or file"                
      end
    end
  end
  
end