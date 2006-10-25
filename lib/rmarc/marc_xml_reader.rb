#--
# $Id: marc_xml_reader.rb,v 1.5 2005/12/11 15:33:22 bpeters Exp $
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
require 'thread'

module RMARC
  
  class RecordStack < SizedQueue
    
    attr_accessor :has_next

  end
  
  class Listener
    
    def tag_start(name, attrs)
      re = /(\w+):(\w+)/
      md = re.match(name)
      name = $2 if ($2 != nil)
      case name
      when "collection"
        @queue.has_next = true
      when "record"
        @record = Record.new
      when "controlfield"
        @field = ControlField.new(attrs["tag"])
      when "datafield"
        @field = DataField.new(attrs["tag"], attrs["ind1"], attrs["ind2"])
      when "subfield"
        @subfield = Subfield.new(attrs["code"])
      end
    end
    
    def text(text)
      @data = text
    end
    
    def tag_end(name)
      re = /(\w+):(\w+)/
      md = re.match(name)
      name = $2 if ($2 != nil)
      case name 
      when "collection"
        @queue.has_next = false
      when "record"
        @queue.push(@record)
      when "leader"
        leader = Leader.new(@data)
        @data = ""
        @record.leader = leader
      when "controlfield"
        @field.data = @data
        @data = ""
        @record.add(@field)
      when "datafield"
        @record.add(@field)
      when "subfield"
        @subfield.data = @data
        @data = ""
        @field.add(@subfield)
      end
    end
    
    def xmldecl(version, encoding, standalone)
    end
    
    def initialize(queue)
      @queue = queue
    end
    
  end
  
  # This class provides an iterator over a collection of MARC XML records.
  #
  # Example usage:
  #
  #   reader = RMARC::MarcXmlReader.new("file.xml")
  #   while reader.has_next
  #       record = reader.next()
  #   end
  #
  # You can also pass a file object:
  # 
  #   input = File.new("file.mrc")
  #   reader = RMARC::MarcXmlReader.new(input)
  #   while reader.has_next
  #       record = reader.next()
  #   end
  #   input.close
  #
  # Or any other IO subclass.
  
  class MarcXmlReader
    
    # Default constructor
    def initialize(input)
      if input.class == String
        @input = File.new(input)
      elsif input.class == File
        @input = input
      else
        throw "Unable to read from path or file"                
      end
      @queue = RecordStack.new(1)
      Thread.new do
        producer = Listener.new(@queue)
        REXML::Document.parse_stream(@input, producer)
      end
    end
    
    # Returns true if the iteration has more records, false otherwise.
    def has_next
      if (@queue.has_next == false && @queue.empty?) 
        return false
      else
        return true
      end
    end
    
    # Returns the next record in the iteration.
    def next
      obj = @queue.pop
      return obj
    end  
  end
  
end