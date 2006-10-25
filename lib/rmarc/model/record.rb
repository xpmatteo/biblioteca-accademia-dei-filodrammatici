#--
# $Id: record.rb,v 1.5 2005/12/11 15:32:37 bpeters Exp $
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
  
  # This class represents a MARC record. 
  #
  # The module Enumerable is included to enable searching within variable fields using each.
  #
  # To iterate over all fields:
  #
  #   record.each { |f| print f }
  #
  # To retrieve the data field for tag 245:
  #
  #   field = record.find {|f| f.tag == '245'}
  
  class Record
    include Enumerable
    
    attr_accessor :leader, :fields
    
    def initialize(leader = nil)
      @leader = leader
      @fields = Array.new
    end
    
    # Adds a field.    
    def add(fld)
      @fields.push(fld)
    end
    
    # Removes a field.
    def remove(fld)
      @fields.delete(fld)
    end
    
    # Implements Enumarable.each to provide an iterator over all variable fields.
    def each
      for field in @fields
        yield field
      end
    end
    
    # Returns a string representation of the record.
    #
    # Example:
    #
    #   Leader: 00714cam a2200205 a 4500
    #   001 12883376
    #   005 20030616111422.0
    #   008 020805s2002    nyu    j      000 1 eng  
    #   020   $a0786808772
    #   020   $a0786816155 (pbk.)
    #   040   $aDLC$cDLC$dDLC
    #   100 1 $aChabon, Michael.
    #   245 10$aSummerland /$cMichael Chabon.
    #   250   $a1st ed.
    #   260   $aNew York :$bMiramax Books/Hyperion Books for Children,$cc2002.
    #   300   $a500 p. ;$c22 cm.
    #   650  1$aFantasy.
    #   650  1$aBaseball$vFiction.
    #   650  1$aMagic$vFiction.
    #
    # Use RMARC::MarcStreamWriter to serialize records to ISO 2709 format.
    def to_s
      a = "Leader: #{@leader.to_s}\n"
      @fields.each { |f| a << "#{f.to_s}\n" }
      return a
    end
  end
  
end