include Unimarc

class Document < ActiveRecord::Base
  
  def self.import_unimarc(filename)
    Unimarc::import(filename)
  end
end
