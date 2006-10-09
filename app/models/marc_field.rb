class MarcField < ActiveRecord::Base
  has_many :subfields, :class_name => 'MarcSubfield', :order => 'code'
end
