#--
# $Id: control_field.rb,v 1.4 2005/12/09 15:25:52 bpeters Exp $
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
  
  # This class represents a control field in a MARC record.

  class ControlField < VariableField
  
    attr_accessor :data
    
    def initialize(tag, data = nil)
      super(tag)
      @data = data
    end
    
    # Returns a string representaiton for a conctrol field.
    #
    # Example:
    # 
    #   001 11939876
    def to_s
      super + "#@data"
    end
  end
  
end