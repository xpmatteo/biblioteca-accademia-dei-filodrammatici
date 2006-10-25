#--
# $Id: constants.rb,v 1.3 2005/12/09 15:26:03 bpeters Exp $
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
  
  class Constants
    
    def Constants.VERSION
      return "0.1.2"
    end
    
    def Constants.RT
      return "\035"
    end
    
    def Constants.FT
      return "\036"
    end
    
    def Constants.US
      return "\037"
    end
    
  end
  
end