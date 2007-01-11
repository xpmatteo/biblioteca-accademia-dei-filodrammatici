class Responsibility < ActiveRecord::Base
  belongs_to :author
  belongs_to :document
end
