#--
# $Id: leader.rb,v 1.5 2005/12/09 15:25:52 bpeters Exp $
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
  
  # This class represents a leader or record label in a MARC record.
  
  class Leader
    
    attr_accessor :record_length, :record_status, :record_type, :impl_defined1, :char_coding, :indicator_count, :subfield_code_length, :base_address, :impl_defined2, :entry_map
    
    def initialize(ldr = nil)
      if (ldr == nil)
        @record_length = 0
        @record_status = "n"
        @record_type = "a"
        @impl_defined1 = "m "
        @char_coding = " "
        @indicator_count = "2"
        @subfield_code_length = "2"
        @base_address = 0
        @impl_defined2 = "a "
        @entry_map = "4500"
      else
        @record_length = ldr[0,5].to_i
        @record_status = ldr[5].chr
        @record_type = ldr[6].chr
        @impl_defined1 = ldr[7,2].to_s
        @char_coding = ldr[9].chr
        @indicator_count = ldr[10].chr
        @subfield_code_length = ldr[11].chr
        @base_address = ldr[12,5].to_i
        @impl_defined2 = ldr[17,3].to_s
        @entry_map = ldr[20,4].to_s
      end
    end
    
    # Returns a string representation for a leader.
    #
    # Example:
    #
    #   00714cam a2200205 a 4500
    def to_s
    "%05d" % @record_length + 
    "#@record_status#@record_type#@impl_defined1#@char_coding" +
    "#@indicator_count#@subfield_code_length" + 
    "%05d" % @base_address + "#@impl_defined2#@entry_map"
    end
  end
  
end