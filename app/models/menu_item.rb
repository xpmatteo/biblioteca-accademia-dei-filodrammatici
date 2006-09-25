class MenuItem < ActiveRecord::Base
  acts_as_tree :order => 'position'
end
