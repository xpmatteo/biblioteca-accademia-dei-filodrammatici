#--
# $Id: data_field.rb,v 1.4 2005/12/09 15:25:52 bpeters Exp $
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
require 'rmarc/model/variable_field'

module RMARC
  
  # This class represents a data field in a MARC record. 
  #
  # The module Enumerable is included to enable searching within subfields using each.
  #
  # To iterate over all subfields:
  #
  #   field.each { |s| print s }
  #
  # To retrieve subfield with code 'a':
  #
  #   field.find {|s| s.code == 'a'}
  #
  # To retrieve subfields with code 'a' through 'c':
  #
  #   field.find_all {|s| ('a'..'c' === s.code)}

  class DataField < VariableField
    include Enumerable
    
    attr_accessor :ind1, :ind2, :subfields
    
    def initialize(tag, ind1, ind2)
      super(tag)
      @ind1 = ind1
      @ind2 = ind2
      @subfields = Array.new
    end
    
    # Adds a subfield.
    def add(subf)
      @subfields.push(subf)
    end
    
    # Removes a subfield
    def remove(subf)
      @subfields.delete(subf)
    end
    
    # Implements Enumarable.each to provide an iterator over all 
    # subfields.
    def each
      for subfield in @subfields
        yield subfield
      end
    end
    
    # Returns a string representation of the data field.
    #
    # Example:
    # 
    #   100 1 $aChabon, Michael.
    def to_s
      a = "" 
      a << super << @ind1 << @ind2
      subfields.each { |s| a << s.to_s }
      return a
    end
  end
  
end